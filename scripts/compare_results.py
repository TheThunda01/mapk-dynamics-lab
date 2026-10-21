#!/usr/bin/env python3
"""Compare all numerical CSV artifacts from two completed benchmark runs."""
import argparse
from pathlib import Path
import numpy as np
import pandas as pd


def compare(reference, candidate):
    reference, candidate = Path(reference), Path(candidate)
    names = {p.name for p in reference.glob("*.csv")}
    if names != {p.name for p in candidate.glob("*.csv")} or not names:
        raise ValueError("CSV file sets differ or are empty")
    for name in sorted(names):
        a, b = pd.read_csv(reference / name), pd.read_csv(candidate / name)
        if a.shape != b.shape or list(a.columns) != list(b.columns):
            raise ValueError(f"Table structure differs: {name}")
        for column in a:
            if pd.api.types.is_numeric_dtype(a[column]) and pd.api.types.is_numeric_dtype(b[column]):
                if not np.isfinite(a[column]).all() or not np.isfinite(b[column]).all():
                    raise ValueError(f"Nonfinite value: {name}/{column}")
                if not np.allclose(a[column], b[column], rtol=1e-9, atol=1e-10, equal_nan=False):
                    raise ValueError(f"Numeric values differ: {name}/{column}")
            elif not a[column].equals(b[column]):
                raise ValueError(f"Values differ: {name}/{column}")
    return len(names)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("reference", type=Path)
    parser.add_argument("candidate", type=Path)
    args = parser.parse_args()
    try:
        count = compare(args.reference, args.candidate)
    except (OSError, ValueError) as exc:
        parser.exit(1, f"comparison failed: {exc}\n")
    print(f"All {count} CSV artifacts agree (rtol=1e-9, atol=1e-10).")
