#!/bin/bash

# ⚡ Quick Deployment Script for Jordi's Blog
# Use this when you just want to deploy without prompts

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}⚡ Quick deploy for Jordi's Blog${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "astro.config.mjs" ]; then
    echo "❌ Error: Run this from the jordisblog directory"
    exit 1
fi

# Add and commit with auto-generated message if there are changes
if ! git diff-index --quiet HEAD --; then
    echo "📝 Committing changes..."
    
    # Generate timestamp-based commit message
    COMMIT_MSG="Update blog $(date '+%Y-%m-%d %H:%M')"
    git add .
    git commit -m "$COMMIT_MSG" || echo "Nothing to commit"
fi

echo "🚀 Pushing to GitHub..."
git push origin main

echo -e "${GREEN}🎯 Changes pushed successfully!${NC}"
echo ""
echo "Vercel will auto-deploy in 1-2 minutes"
echo "Check your Vercel dashboard for deployment status"

# Show the deployed URL from previous deploy if available
if [ -d ".vercel" ]; then
    echo ""
    echo "🔗 Project link:"
    echo "https://vercel.com/dashboard/jordisblog"
fi

echo ""
echo -e "${GREEN}✅ Deployment initiated!${NC}"