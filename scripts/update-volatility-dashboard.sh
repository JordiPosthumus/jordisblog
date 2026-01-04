#!/bin/bash

# Volatility Dashboard Automation Script
# This script fetches data, calculates volatility, and deploys to Vercel

echo "Starting Volatility Dashboard Update - $(date)"

# Change to blog directory
cd /Users/jordiposthumus/Documents/Projects/SilverBug/jordisblog

# Step 1: Fetch Apple stock data using Python
echo "Step 1: Fetching Apple stock data..."
source .venv/bin/activate && python3 scripts/fetch-apple-data.py

if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch Apple data"
    exit 1
fi

# Step 2: Calculate volatility for Bitcoin and Apple using R
echo "Step 2: Calculating volatility metrics..."
Rscript scripts/calculate-bitcoin-volatility.R

if [ $? -ne 0 ]; then
    echo "Error: Failed to calculate volatility"
    exit 1
fi

# Step 3: Commit changes to git
echo "Step 3: Committing changes..."
git add public/bitcoin-volatility.json public/aapl-data.json

# Check if there are changes to commit
if git diff --quiet && git diff --cached --quiet; then
    echo "No changes to commit"
else
    git config user.email "jordi@localhost"
    git config user.name "Jordi Local Bot"
    
    git commit -m "Update volatility data - $(date +%Y-%m-%d)"
    
    # Step 4: Push to GitHub (Vercel will auto-deploy)
    echo "Step 4: Pushing to GitHub..."
    git push
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully pushed to GitHub. Vercel deployment will start shortly."
    else
        echo "❌ Failed to push to GitHub"
        exit 1
    fi
fi

echo "Volatility Dashboard Update Complete - $(date)"