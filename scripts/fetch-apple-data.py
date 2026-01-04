#!/usr/bin/env python3
import yfinance as yf
import json
from datetime import datetime, timedelta
import sys


def fetch_apple_stock_data(years=3):
    """Fetch Apple stock data for specified number of years"""

    end_date = datetime.now()
    start_date = end_date - timedelta(days=years * 365)

    print(
        f"Fetching Apple stock data from {start_date.strftime('%Y-%m-%d')} to present...",
        file=sys.stderr,
    )

    try:
        ticker = yf.Ticker("AAPL")
        hist = ticker.history(start=start_date, end=end_date)

        if hist.empty:
            print("Error: No data retrieved from yfinance", file=sys.stderr)
            return None

        # Convert to the format expected by R script
        data = []
        for date, row in hist.iterrows():
            data.append(
                {"date": date.strftime("%Y-%m-%d"), "price": float(row["Close"])}
            )

        print(f"Fetched {len(data)} days of Apple stock data", file=sys.stderr)

        # Save to JSON file
        output_file = "/Users/jordiposthumus/Documents/Projects/SilverBug/jordisblog/public/aapl-data.json"
        with open(output_file, "w") as f:
            json.dump(data, f)

        print(f"Saved Apple data to {output_file}", file=sys.stderr)
        return output_file

    except Exception as e:
        print(f"Error fetching Apple data: {e}", file=sys.stderr)
        return None


if __name__ == "__main__":
    result = fetch_apple_stock_data(years=3)
    sys.exit(0 if result else 1)
