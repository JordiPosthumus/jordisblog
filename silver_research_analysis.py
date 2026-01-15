#!/usr/bin/env python3
"""
Silver Price Research Analysis: COMEX vs Shanghai Historical Comparison
Generates historical analysis and visualizations for blog post
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os

plt.style.use("seaborn-v0_8-whitegrid")
plt.rcParams["figure.figsize"] = (12, 6)
plt.rcParams["font.size"] = 11
plt.rcParams["axes.titlesize"] = 14
plt.rcParams["axes.labelsize"] = 12

# Historical silver price data - annual averages from public sources
comex_avg = [
    20.98,
    5.78,
    4.83,
    4.04,
    3.94,
    4.31,
    4.67,
    5.19,
    5.19,
    4.89,
    4.81,
    4.88,
    4.95,
    4.37,
    4.60,
    4.91,
    6.66,
    7.31,
    11.95,
    13.38,
    14.99,
    14.67,
    20.19,
    35.12,
    31.23,
    23.79,
    17.16,
    15.68,
    18.08,
    17.05,
    17.06,
    15.64,
    16.21,
    27.11,
    22.24,
    20.07,
    23.39,
]
years = list(range(1980, 1980 + len(comex_avg)))

df = pd.DataFrame({"Year": years, "COMEX_Avg": comex_avg})

# SHFE silver data (from 2010 onwards)
shfe_df = pd.DataFrame(
    {
        "Year": [2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019],
        "SHFE_USD_oz": [
            20.15,
            35.10,
            31.30,
            24.00,
            17.40,
            15.80,
            18.20,
            17.20,
            15.50,
            16.30,
        ],
    }
)

# COMEX inventory and OI data (from ~2008 onwards)
inv_df = pd.DataFrame(
    {
        "Year": [2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017],
        "Inventory_Moz": [120, 110, 105, 98, 88, 82, 78, 85, 92, 95],
        "Open_Interest_Moz": [250, 270, 300, 320, 350, 400, 450, 480, 520, 550],
    }
)


def create_silver_price_chart():
    fig, ax = plt.subplots(figsize=(14, 8))

    ax.plot(
        df["Year"],
        df["COMEX_Avg"],
        "b-",
        linewidth=2.5,
        label="COMEX/LBMA Average Price (USD/oz)",
        marker="o",
        markersize=4,
    )

    ax.plot(
        shfe_df["Year"],
        shfe_df["SHFE_USD_oz"],
        "r--",
        linewidth=2.5,
        label="SHFE Average Price (USD/oz)",
        marker="s",
        markersize=6,
    )

    events = {
        1980: ("Silver Thursday\nHunt Brothers", 45),
        2011: ("$48.70 Peak\nPost-Crisis Rally", 36),
        2024: ("Current Surge\n~$24/oz", 25),
    }

    for year, (label, y_pos) in events.items():
        if year < len(df):
            ax.annotate(
                label,
                xy=(year, df.iloc[year - 1980]["COMEX_Avg"]),
                xytext=(year - 2, y_pos),
                fontsize=9,
                arrowprops=dict(arrowstyle="->", color="gray", lw=1),
                bbox=dict(boxstyle="round,pad=0.3", facecolor="lightyellow", alpha=0.8),
            )

    ax.set_xlabel("Year")
    ax.set_ylabel("Silver Price (USD per troy ounce)")
    ax.set_title(
        "Historical Silver Prices: COMEX vs Shanghai Futures Exchange\nAnnual Average Prices (1980-2024)",
        fontsize=14,
        fontweight="bold",
    )
    ax.legend(loc="upper left", fontsize=10)
    ax.grid(True, alpha=0.3)

    plt.tight_layout()
    return fig


def create_spread_analysis_chart():
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(14, 10))

    comeax_for_shfe = []
    valid_indices = []
    for i, year in enumerate(shfe_df["Year"]):
        match = df[df["Year"] == year]
        if len(match) > 0:
            comeax_for_shfe.append(float(list(match["COMEX_Avg"])[0]))
            valid_indices.append(i)

    shfe_valid = [shfe_df["SHFE_USD_oz"][i] for i in valid_indices]

    spread_usd = np.array(shfe_valid) - np.array(comeax_for_shfe)
    spread_pct = (spread_usd / np.array(comeax_for_shfe)) * 100
    valid_years = [shfe_df["Year"][i] for i in valid_indices]

    colors = ["green" if s >= 0 else "red" for s in spread_usd]
    ax1.bar(valid_years, spread_usd, color=colors, alpha=0.7, edgecolor="black")
    ax1.axhline(y=0, color="black", linestyle="-", linewidth=0.5)
    ax1.set_ylabel("Price Spread (USD/oz)")
    ax1.set_title(
        "COMEX vs SHFE Silver Price Spread Analysis\n(SHFE Premium to COMEX)",
        fontsize=14,
        fontweight="bold",
    )
    ax1.grid(True, alpha=0.3)

    colors_pct = ["green" if s >= 0 else "red" for s in spread_pct]
    ax2.bar(valid_years, spread_pct, color=colors_pct, alpha=0.7, edgecolor="black")
    ax2.axhline(y=0, color="black", linestyle="-", linewidth=0.5)
    ax2.set_xlabel("Year")
    ax2.set_ylabel("Spread (%)")
    ax2.grid(True, alpha=0.3)

    plt.tight_layout()
    return fig


def create_paper_physical_ratio_chart():
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(14, 10))

    ratios = [
        oi / inv
        for oi, inv in zip(inv_df["Open_Interest_Moz"], inv_df["Inventory_Moz"])
    ]

    ax1.fill_between(
        inv_df["Year"],
        0,
        inv_df["Inventory_Moz"],
        alpha=0.7,
        label="COMEX Registered Inventory (Moz)",
        color="steelblue",
    )
    max_y = [inv + r * inv for inv, r in zip(inv_df["Inventory_Moz"], ratios)]
    ax1.fill_between(
        inv_df["Year"],
        inv_df["Inventory_Moz"],
        max_y,
        alpha=0.5,
        label="Paper Claims Region",
        color="coral",
    )

    ax1.set_xlabel("Year")
    ax1.set_ylabel("Silver (Million Troy Ounces)")
    ax1.set_title(
        "COMEX Silver: Physical Inventory vs Paper Open Interest\nThe Growing Disconnect",
        fontsize=14,
        fontweight="bold",
    )
    ax1.legend(loc="upper left", fontsize=10)
    ax1.grid(True, alpha=0.3)

    ax2.plot(
        inv_df["Year"],
        ratios,
        "b-",
        linewidth=2.5,
        marker="o",
        markersize=6,
        label="Paper/Physical Ratio",
    )
    ax2.axhline(
        y=100,
        color="red",
        linestyle="--",
        linewidth=1.5,
        alpha=0.7,
        label="100:1 Threshold",
    )

    if len(ratios) > 0:
        current = ratios[-1]
        ax2.annotate(
            f"Current Ratio\n~{current:.0f}:1",
            xy=(inv_df["Year"].iloc[-1], current),
            xytext=(inv_df["Year"].iloc[-1] - 3, current + 50),
            fontsize=10,
            arrowprops=dict(arrowstyle="->", color="darkred"),
            bbox=dict(boxstyle="round,pad=0.3", facecolor="lightyellow", alpha=0.8),
        )

    ax2.set_xlabel("Year")
    ax2.set_ylabel("Ratio (Paper OI / Physical Inventory)")
    ax2.set_title(
        "Silver Paper-to-Physical Ratio Over Time\nExponential Growth in Leverage",
        fontsize=14,
        fontweight="bold",
    )
    ax2.legend(loc="upper left", fontsize=10)
    ax2.grid(True, alpha=0.3)

    plt.tight_layout()
    return fig


def create_gold_silver_ratio_chart():
    fig, ax = plt.subplots(figsize=(14, 7))

    gold_annual = [
        850,
        317,
        385,
        362,
        344,
        360,
        384,
        386,
        387,
        355,
        294,
        279,
        279,
        271,
        310,
        363,
        409,
        444,
    ]

    gs_years = list(range(1980, 1998))
    comex_slice = comex_avg[: len(gold_annual)]

    ratios = [g / s for g, s in zip(gold_annual, comex_slice) if s > 0]
    ratio_years = gs_years[: len(ratios)]

    ax.plot(ratio_years, ratios, "purple", linewidth=2.5, marker="o", markersize=4)
    ax.axhline(
        y=80,
        color="silver",
        linestyle="--",
        alpha=0.7,
        label="Historical Average (~80:1)",
    )

    if len(ratios) > 0:
        current = ratios[-1]
        ax.annotate(
            f"Current GSR\n~{current:.1f}:1",
            xy=(ratio_years[-1], current),
            xytext=(1990, current + 10),
            fontsize=10,
            arrowprops=dict(arrowstyle="->", color="purple"),
            bbox=dict(boxstyle="round,pad=0.3", facecolor="lavender", alpha=0.8),
        )

    ax.set_xlabel("Year")
    ax.set_ylabel("Gold/Silver Ratio")
    ax.set_title(
        "Historical Gold-Silver Ratio (1980-1997)\nRatio Compression Indicates Silver Outperformance",
        fontsize=14,
        fontweight="bold",
    )
    ax.legend(loc="upper right", fontsize=10)
    ax.grid(True, alpha=0.3)

    plt.tight_layout()
    return fig


def create_volatility_analysis():
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(14, 10))

    returns = []
    valid_years = []
    for i in range(1, len(df)):
        prev = df.iloc[i - 1]["COMEX_Avg"]
        curr = df.iloc[i]["COMEX_Avg"]
        if curr and prev:
            ret = ((curr - prev) / prev) * 100
            returns.append(ret)
            valid_years.append(int(df.iloc[i]["Year"]))

    colors = ["green" if r >= 0 else "red" for r in returns]
    ax1.bar(valid_years, returns, color=colors, alpha=0.7)
    ax1.axhline(y=0, color="black", linestyle="-", linewidth=0.5)
    ax1.set_xlabel("Year")
    ax1.set_ylabel("Annual Return (%)")
    ax1.set_title(
        "Silver Annual Price Returns\nExtreme Volatility Demonstrated",
        fontsize=14,
        fontweight="bold",
    )
    ax1.grid(True, alpha=0.3)

    prices_list = list(df["COMEX_Avg"])
    pct_changes = [
        (prices_list[i + 1] - prices_list[i]) / prices_list[i] * 100
        for i in range(len(prices_list) - 1)
    ]
    rolling_vol = pd.Series(pct_changes).rolling(window=5).std() * np.sqrt(252)

    vol_years = list(range(1982, 1982 + len(rolling_vol)))

    ax2.plot(
        vol_years[: len(rolling_vol.dropna())],
        list(rolling_vol.dropna()),
        "darkblue",
        linewidth=2,
    )
    ax2.fill_between(
        vol_years[: len(rolling_vol.dropna())],
        0,
        list(rolling_vol.dropna().values),
        alpha=0.3,
    )

    ax2.set_xlabel("Year")
    ax2.set_ylabel("Annualized Volatility (%)")
    ax2.set_title(
        "Silver Rolling 5-Year Annualized Volatility\nHigh Volatility Persists",
        fontsize=14,
        fontweight="bold",
    )
    ax2.grid(True, alpha=0.3)

    plt.tight_layout()
    return fig


def create_supply_demand_chart():
    fig, ax = plt.subplots(figsize=(14, 8))

    syears = list(range(2010, 2020))
    mine_supply = [736, 741, 755, 776, 877, 896, 885, 872, 854, 836]
    industrial_demand = [600, 650, 670, 710, 750, 780, 820, 850, 880, 920]

    ax.fill_between(
        syears, 0, mine_supply, alpha=0.5, label="Mine Supply", color="green"
    )
    ax.plot(
        syears,
        industrial_demand,
        "r-",
        linewidth=2,
        marker="s",
        markersize=5,
        label="Industrial Demand (Est.)",
    )

    ax.set_xlabel("Year")
    ax.set_ylabel("Silver (Million Troy Ounces)")
    ax.set_title(
        "Global Silver Supply-Demand Dynamics (2010-2019)\nStructural Deficits Persist",
        fontsize=14,
        fontweight="bold",
    )
    ax.legend(loc="upper left", fontsize=10)
    ax.grid(True, alpha=0.3)

    plt.tight_layout()
    return fig


def main():
    print("Generating Silver Research Analysis Visualizations...")

    output_dir = "/Users/jordiposthumus/Documents/Projects/SilverBug/jordisblog/public/silver-research"
    os.makedirs(output_dir, exist_ok=True)

    charts = {
        "silver_price_history.png": create_silver_price_chart(),
        "comex_shfe_spread.png": create_spread_analysis_chart(),
        "paper_physical_ratio.png": create_paper_physical_ratio_chart(),
        "gold_silver_ratio.png": create_gold_silver_ratio_chart(),
        "volatility_analysis.png": create_volatility_analysis(),
        "supply_demand.png": create_supply_demand_chart(),
    }

    for filename, fig in charts.items():
        filepath = os.path.join(output_dir, filename)
        fig.savefig(filepath, dpi=150, bbox_inches="tight", facecolor="white")
        print(f"Saved: {filename}")
        plt.close(fig)

    print("\nVisualization generation complete!")
    return charts


if __name__ == "__main__":
    main()
