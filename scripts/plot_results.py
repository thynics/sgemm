#!/usr/bin/env python3
"""Placeholder script for plotting benchmark CSV results."""

import argparse


def main() -> None:
    parser = argparse.ArgumentParser(description="Plot sgemm benchmark results")
    parser.add_argument("--csv", required=True, help="Path to CSV file")
    parser.add_argument("--out", default="results/figures", help="Output directory")
    args = parser.parse_args()
    print(f"TODO: implement plotting for {args.csv} -> {args.out}")


if __name__ == "__main__":
    main()
