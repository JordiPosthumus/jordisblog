# Volatility Dashboard - Local Automation Setup

## Prerequisites

### 1. Install Python and yfinance
```bash
# Check if python3 is installed
python3 --version

# Install yfinance library
pip3 install yfinance
```

### 2. Test the stock data fetchers
```bash
cd /Users/jordiposthumus/Documents/Projects/SilverBug/jordisblog

# Test Apple data
python3 scripts/fetch-apple-data.py

# Test MicroStrategy data
python3 scripts/fetch-mstr-data.py

# Test Silver data
python3 scripts/fetch-silver-data.py
```

### 3. Test the R script with Apple data
```bash
Rscript scripts/calculate-bitcoin-volatility.R
```

### 4. Test the full update process
```bash
./scripts/update-volatility-dashboard.sh
```

## Setting Up Daily Automation

### Option 1: Using macOS Launchd (Recommended)

Create file `~/Library/LaunchAgents/com.jordisblog.volatility-update.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.jordisblog.volatility-update</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/jordiposthumus/Documents/Projects/SilverBug/jordisblog/scripts/update-volatility-dashboard.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>9</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>/tmp/volatility-update.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/volatility-update-error.log</string>
</dict>
</plist>
```

Load the launch agent:
```bash
launchctl load ~/Library/LaunchAgents/com.jordisblog.volatility-update.plist
```

### Option 2: Using Cron

```bash
# Edit crontab
crontab -e

# Add this line (runs daily at 9 AM)
0 9 * * * /Users/jordiposthumus/Documents/Projects/SilverBug/jordisblog/scripts/update-volatility-dashboard.sh >> /tmp/volatility-update.log 2>&1
```

## Manual Update

Run anytime:
```bash
./scripts/update-volatility-dashboard.sh
```

## How It Works

1. **Python scripts** fetch stock data from Yahoo Finance (Apple, MSTR, Silver/SLV) - 3 years
2. **R script** calculates volatility for Bitcoin, Apple, MSTR, and Silver
3. **Bash script** commits changes to git
4. **Vercel** automatically deploys when GitHub is updated

## Troubleshooting

### Check logs:
```bash
cat /tmp/volatility-update.log
cat /tmp/volatility-update-error.log
```

### Manually run with debug output:
```bash
bash -x ./scripts/update-volatility-dashboard.sh
```

### Verify Apple data:
```bash
cat public/aapl-data.json | head -20
```

### Verify volatility data:
```bash
cat public/bitcoin-volatility.json | head -20
```

### Verify MSTR data:
```bash
cat public/mstr-data.json | head -20
```

### Verify Silver data:
```bash
cat public/silver-data.json | head -20
```

## Benefits vs GitHub Actions

✅ **Local approach:**
- No API restrictions (Yahoo Finance works locally)
- Full control over data sources
- Can use any Python/R libraries
- Faster development and testing

❌ **GitHub Actions:**
- API rate limits
- Restricted data access
- Slower iteration cycle