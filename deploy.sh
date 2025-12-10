#!/bin/bash

# 🚀 Jordi's Blog Deployment Script
# This script automates the complete deployment workflow for Vercel

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if we're in the right directory
check_directory() {
    if [ ! -f "astro.config.mjs" ] || [ ! -d "src" ]; then
        log_error "This doesn't look like an Astro blog directory"
        echo "Current directory: $(pwd)"
        echo "Please run this script from the jordisblog root directory"
        exit 1
    fi
}

# Check git status and handle changes
handle_git_changes() {
    log_info "Checking Git status..."
    
    if git diff-index --quiet HEAD --; then
        log_success "No uncommitted changes"
    else
        log_warning "You have uncommitted changes:"
        
        # Show what's changed
        echo ""
        git status --porcelain | head -10
        
        # Ask if user wants to commit
        echo ""
        read -p "Do you want to commit these changes? (y/N): " -n 1 -r
        echo ""
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            read -p "Enter commit message: " COMMIT_MESSAGE
            
            if [ -z "$COMMIT_MESSAGE" ]; then
                log_error "Commit message required"
                exit 1
            fi
            
            git add .
            git commit -m "$COMMIT_MESSAGE"
            
            if [ $? -eq 0 ]; then
                log_success "Changes committed successfully"
            else
                log_error "Failed to commit changes"
                exit 1
            fi
        else
            log_warning "Deploying with current committed changes only"
            echo "Tip: Run 'git add . && git commit -m \"Your message\"' to include your changes"
        fi
    fi
    
    # Push if needed
    echo ""
    read -p "Push to GitHub and deploy? (Y/n): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        log_info "Pushing to GitHub..."
        
        if git push origin main; then
            log_success "Pushed to GitHub successfully"
            
            echo ""
            echo -e "${GREEN}🎯 Your changes have been pushed to GitHub!${NC}"
            echo -e "${BLUE}Vercel will automatically deploy them in about 1-2 minutes.${NC}"
            echo ""
            
            # Option to force immediate deploy
            read -p "Force immediate Vercel deployment? (y/N): " -n 1 -r
            echo ""
            
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                log_info "Triggering immediate Vercel deployment..."
                
                if npx vercel --prod; then
                    log_success "Vercel deployment triggered successfully!"
                else
                    log_error "Failed to trigger Vercel deployment"
                    exit 1
                fi
            else
                echo -e "${BLUE}ℹ️  Your changes will be deployed automatically by Vercel.${NC}"
            fi
            
        else
            log_error "Failed to push to GitHub"
            echo ""
            echo "Troubleshooting steps:"
            echo "1. Check your internet connection"
            echo "2. Verify you're authenticated with GitHub"
            echo "3. Check if your repository exists: https://github.com/JordiPosthumus/jordisblog"
            exit 1
        fi
    else
        log_warning "Deployment cancelled by user"
    fi
}

# Build and test locally first (optional)
build_locally() {
    log_info "Building project locally to check for errors..."
    
    # Clean previous build
    if [ -d "dist" ]; then
        rm -rf dist
        log_info "Cleaned previous build"
    fi
    
    # Build project
    if npm run build; then
        log_success "Local build successful"
        
        # Check dist directory exists and has content
        if [ -d "dist" ] && [ "$(ls -A dist)" ]; then
            log_success "Build output verified"
        else
            log_error "Build directory empty or missing"
            exit 1
        fi
        
    else
        log_error "Local build failed - deployment aborted"
        echo ""
        echo "Please fix the errors above before deploying."
        exit 1
    fi
    
    # Optional: serve locally for preview
    echo ""
    read -p "Preview the build locally? (y/N): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Starting preview server..."
        echo ""
        npm run dev &
        
        # Give it a moment to start
        sleep 2
        
        echo -e "${GREEN}🚀 Preview server running!${NC}"
        echo "Local URL: http://localhost:4321"
        echo ""
        
        read -p "Press Enter when you're done previewing (or Ctrl+C to cancel)..."
        
        # Kill the background dev server
        pkill -f "npm run dev" || true
        
    fi
    
    # Clean local build to avoid confusion
    rm -rf dist
}

# Show deployment summary
show_summary() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${GREEN}🎉 Deployment Summary${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Get latest commit
    if git rev-parse HEAD >/dev/null 2>&1; then
        COMMIT_MSG=$(git log -1 --pretty=format:"%s")
        COMMIT_HASH=$(git rev-parse --short HEAD)
        
        echo -e "${BLUE}📝 Latest commit:${NC}"
        echo "   $COMMIT_MSG ($COMMIT_HASH)"
    fi
    
    # Repository info
    echo -e "${BLUE}🔗 Repository:${NC}"
    echo "   https://github.com/JordiPosthumus/jordisblog"
    
    # Vercel project
    echo -e "${BLUE}🌐 Vercel Project:${NC}"
    
    if [ -f ".vercel/project.json" ]; then
        PROJECT_ID=$(jq -r '.projectName' .vercel/project.json)
        echo "   https://vercel.com/dashboard/${PROJECT_ID}"
    fi
    
    # Next steps
    echo ""
    echo -e "${YELLOW}⏱️  What happens next:${NC}"
    echo "   • Vercel is building your site (1-2 minutes)"
    echo "   • Check deployment status in Vercel dashboard"
    echo "   • Your site will be live at the provided URL"
    echo ""
    
    # Check deployment status
    if command -v vercel >/dev/null 2>&1; then
        echo "🔍 Checking latest deployment..."
        sleep 3
        
        if vercel list >/dev/null 2>&1; then
            echo ""
            vercel list | head -3
        fi
    fi
    
    echo ""
}

# Main deployment function
main() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${GREEN}🚀 Jordi's Blog Deployment${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # Check prerequisites
    check_directory
    
    # Optional: Build locally first
    echo "Do you want to build and test locally before deploying?"
    read -p "(Recommended for catching errors) (Y/n): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        build_locally
    fi
    
    # Handle Git and deployment
    handle_git_changes
    
    # Show summary
    show_summary
}

# Help function
show_help() {
    echo "🚀 Jordi's Blog Deployment Script"
    echo ""
    echo "Usage: ./deploy.sh [options]"
    echo ""
    echo "Options:"
    echo "  --help, -h      Show this help message"
    echo "  --skip-build    Skip local build step"
    echo ""
    echo "This script will:"
    echo "  ✓ Check Git status"
    echo "  ✓ Optionally build locally"
    echo "  ✓ Prompt to commit changes"
    echo "  ✓ Push to GitHub"
    echo "  ✓ Trigger Vercel deployment"
    echo "  ✓ Show deployment status"
}

# Parse command line arguments
case "${1:-}" in
    --help|-h)
        show_help
        exit 0
        ;;
    --skip-build)
        BUILD_LOCAL=false
        ;;
    "")
        # Interactive mode - nothing to change
        ;;
    *)
        echo "Unknown option: $1"
        show_help
        exit 1
        ;;
esac

# Run main deployment
main