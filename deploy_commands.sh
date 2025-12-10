#!/bin/bash

echo "🚀 Setting up Git repository for Jordi's Blog..."
git init
git add .
git commit -m "✨ Initial blog setup with comprehensive silver squeeze analysis"
git branch -M main

echo ""
echo "📋 Next steps:"
echo "1. Create a new repository on GitHub called 'jordisblog'"
echo "2. Run these commands:"
echo ""
echo "git remote add origin https://github.com/YOUR_USERNAME/jordisblog.git"
echo "git push -u origin main"
echo ""
echo "3. Go to vercel.com and deploy your GitHub repo"
echo "4. Add jordisblog.com as custom domain in Vercel settings"
