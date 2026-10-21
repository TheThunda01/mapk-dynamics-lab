#!/usr/bin/env python3
"""Run the offline benchmark with validated, pinned model inputs."""
import argparse
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from mapk_lab.experiment import run
from mapk_lab.model import ROOT


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--out", type=Path, default=ROOT / "results")
    parser.add_argument("--data-dir", type=Path, default=ROOT / "data")
    parser.add_argument("--seeds", type=int, default=20)
    parser.add_argument("--grid-size", type=int, default=7)
    args = parser.parse_args()
    try:
        run(args.out, args.data_dir, args.seeds, args.grid_size)
    except (ValueError, OSError, KeyError) as exc:
        parser.exit(2, f"error: {exc}\n")
    print(f"Wrote benchmark to {args.out}")


if __name__ == "__main__":
    main()
