"""Draw the implemented virtual loop and replot committed final-budget results."""
from __future__ import annotations

import csv
import hashlib
from html import escape
import json
from pathlib import Path
import xml.etree.ElementTree as ET

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs" / "figures"
INK, TEAL, BLUE, AMBER, MUTED, PALE = "#203449", "#007F7B", "#386CB0", "#B87824", "#596773", "#EEF3F6"


def text(x: int, y: int, lines: list[str], size: int = 18, color: str = INK,
         weight: str = "normal") -> str:
    return "".join(f'<text x="{x}" y="{y + 25*i}" font-size="{size}" fill="{color}" '
                   f'font-weight="{weight}" text-anchor="middle">{escape(line)}</text>' for i, line in enumerate(lines))


def box(x: int, y: int, w: int, h: int, title: str, lines: list[str], color: str) -> str:
    return (f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="12" fill="white" stroke="{color}" stroke-width="2"/>'
            + text(x+w//2, y+30, [title], 20, color, "bold") + text(x+w//2, y+61, lines, 17))


def path(d: str, dashed: bool = False) -> str:
    return f'<path d="{d}" fill="none" stroke="{MUTED}" stroke-width="2.5" marker-end="url(#arrow)"' + (' stroke-dasharray="7 5"' if dashed else '') + '/>'


def describe_svg(filename: Path, title: str, description: str) -> None:
    ET.register_namespace("", "http://www.w3.org/2000/svg")
    ET.register_namespace("xlink", "http://www.w3.org/1999/xlink")
    tree = ET.parse(filename)
    root = tree.getroot()
    root.insert(0, ET.Element("{http://www.w3.org/2000/svg}title")); root[0].text = title
    root.insert(1, ET.Element("{http://www.w3.org/2000/svg}desc")); root[1].text = description
    tree.write(filename, encoding="utf-8", xml_declaration=True)


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    diagram = OUT / "virtual-loop.svg"
    parts = ['<svg xmlns="http://www.w3.org/2000/svg" width="960" height="730" viewBox="0 0 960 730" role="img">',
             '<title>Data access in the implemented virtual MAPK measurement loop</title>',
             '<desc>A hidden simulator supplies only the selected noisy observation. A posterior update changes weights over 49 allowed hypotheses, and the policy uses those weights and predicted means to select another candidate. Only the evaluator receives the hidden noiseless curve. The diagram is a software-data-access schematic, not laboratory equipment.</desc>',
             '<rect width="960" height="730" fill="white"/><g font-family="DejaVu Sans, sans-serif">',
             f'<defs><marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto"><path d="M0,0 L10,5 L0,10 Z" fill="{MUTED}"/></marker></defs>',
             text(480,36,["What the selection policy can and cannot see"],26,INK,"bold"),
             text(480,66,["Implemented software loop — all observations are simulated"],17,MUTED),
             box(50,105,360,125,"Hidden simulator",["One generating parameter setting", "Candidate-indexed noisy observations", "Hidden noiseless evaluation curve"],AMBER),
             box(550,105,360,125,"Allowed model predictions",["49 hypotheses; 72 candidates", "Fixed model and known noise scale", "Available before selection"],BLUE),
             box(50,310,360,100,"Revealed observation",["One selected candidate ID and value", "Earlier observations remain available"],TEAL),
             box(550,310,360,100,"Posterior update",["Weights over the allowed hypotheses", "Conditional on model, grid and noise"],TEAL),
             box(300,505,360,100,"Selection policy",["Predicted means + current weights", "Selected IDs; no hidden truth"],BLUE),
             path("M230,230 L230,310"), text(230,262,["reveal selected value"],16,MUTED),
             path("M410,360 L550,360"), text(480,338,["update"],16,MUTED),
             path("M730,230 L730,310"),
             path("M730,410 L730,465 L590,505"),
             path("M370,505 L230,465 L230,410"), text(335,455,["next query ID"],16,MUTED),
             box(50,625,860,70,"Evaluator only",["Hidden curve + posterior predictions → curve error; weights → entropy"],AMBER),
             path("M50,165 L25,165 L25,660 L50,660",True),
             path("M730,410 L935,410 L935,660 L910,660",True),
             text(480,720,["Solid arrows: learning loop. Dashed arrows: evaluation access, never policy input."],16,MUTED),
             '</g></svg>']
    diagram.write_text("\n".join(parts)+"\n"); ET.parse(diagram)

    sources = [ROOT / "results/trials.csv", ROOT / "results/stress_trials.csv"]
    selected = []
    for source, label in zip(sources, ("Grid-matched generating points", "One off-grid point; noise repeats")):
        with source.open(newline="") as handle:
            rows = [r for r in csv.DictReader(handle) if r["policy"] == "variance_guided" and int(r["budget"]) == 12]
        selected.append((label, rows))
    assert [len(rows) for _, rows in selected] == [20, 6]
    plt.rcParams.update({"font.family": "DejaVu Sans", "font.size": 12, "text.color": INK,
                         "axes.labelcolor": INK, "xtick.color": MUTED, "ytick.color": MUTED,
                         "svg.fonttype": "none", "svg.hashsalt": "mapk-documentation-v1"})
    fig, ax = plt.subplots(figsize=(8.3, 5.5))
    for (label, rows), color, marker in zip(selected, (TEAL, AMBER), ("o", "^")):
        ax.scatter([float(r["entropy_nats"]) for r in rows], [float(r["prediction_rmse"]) for r in rows],
                   c=color, marker=marker, s=70, alpha=0.85, label=f"{label} (n={len(rows)})",
                   edgecolor="white", linewidth=0.6)
    ax.set(xlabel="Final posterior entropy (nats)", ylabel="Final curve RMSE (fraction units)",
           xlim=(-0.035,1.09), ylim=(-0.0005,0.016))
    ax.spines[["top","right"]].set_visible(False)
    ax.grid(color="#DCE4E9", linewidth=0.7); ax.set_axisbelow(True)
    ax.legend(frameon=False, fontsize=10, loc="upper left")
    fig.suptitle("Posterior concentration and prediction error are different summaries",fontsize=15,y=0.97)
    fig.text(0.5,0.9,"Variance-guided policy • budget 12 • committed virtual experiments",ha="center",color=MUTED,fontsize=11)
    fig.subplots_adjust(left=0.13,right=0.97,bottom=0.16,top=0.81)
    chart = OUT / "entropy-and-error.svg"
    fig.savefig(chart,metadata={"Date":None});plt.close(fig)
    describe_svg(chart,"Final entropy and curve error in recorded virtual MAPK experiments",
                 "Scatter plot of 20 grid-matched generating points and six noise repeats at one off-grid point, "
                 "using variance-guided selection at budget 12. Entropy measures allowed-hypothesis weight dispersion; "
                 "curve RMSE compares predictions with the hidden noiseless trajectory. Different truth scenarios "
                 "prevent interpreting the between-group contrast as a causal effect of grid mismatch.")
    manifest={"diagram_kind":"conceptual software data-access schematic",
              "chart_selection":{"policy":"variance_guided","budget":12,"grid_matched_rows":20,"off_grid_rows":6},
              "source_sha256":{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sources},
              "output_sha256":{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in (diagram,chart)}}
    (OUT / "figure-manifest.json").write_text(json.dumps(manifest,indent=2)+"\n")


if __name__ == "__main__":
    main()
