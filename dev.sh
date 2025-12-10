#!/bin/bash

# 🔧 Development Helper Script for Jordi's Blog
# Quick commands for common development tasks

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

show_help() {
    echo -e "${GREEN}🔧 Dev Tools for Jordi's Blog${NC}"
    echo ""
    echo "Usage: ./dev.sh [command]"
    echo ""
    echo "Commands:"
    echo -e "${BLUE}  install${NC}     Install dependencies"
    echo -e "${BLUE}  dev${NC}         Start development server (localhost:4321)"
    echo -e "${BLUE}  build${NC}       Build for production"
    echo -e "${BLUE}  preview${NC}     Preview production build locally"  
    echo -e "${BLUE}  clean${NC}       Clean dist and node_modules"
    echo -e "${BLUE}  deploy${NC}      Full deployment with prompts"
    echo -e "${BLUE}  quick-deploy${NC} Quick push and deploy (no prompts)"
    echo -e "${BLUE}  status${NC}      Show git and deployment status"
    echo -e "${BLUE}  help${NC}        Show this help message"
    echo ""
}

case "${1:-}" in
    "")
        show_help
        ;;
    install)
        echo -e "${BLUE}📦 Installing dependencies...${NC}"
        npm install
        ;;
    dev)
        echo -e "${BLUE}🚀 Starting development server...${NC}"
        npm run dev
        ;;
    build)
        echo -e "${BLUE}🏗️  Building for production...${NC}"
        npm run build
        echo -e "${GREEN}✅ Build complete! Run './dev.sh preview' to test locally${NC}"
        ;;
    preview)
        echo -e "${BLUE}👀 Starting preview server...${NC}"
        npm run preview
        ;;
    clean)
        echo -e "${BLUE}🧹 Cleaning build artifacts...${NC}"
        rm -rf dist .astro
        echo -e "${GREEN}✅ Clean complete!${NC}"
        ;;
    deploy)
        ./deploy.sh
        ;;
    quick-deploy)
        ./deploy-quick.sh
        ;;
    status)
        echo -e "${GREEN}📊 Status Check${NC}"
        echo ""
        
        # Git status
        if git rev-parse HEAD >/dev/null 2>&1; then
            echo -e "${BLUE}📝 Git Status:${NC}"
            git status --porcelain | head -5 || echo "   ✅ Working directory clean"
            
            echo ""
            echo -e "${BLUE}🔗 Latest commit:${NC}"
            git log -1 --pretty=format:"   %s (%h)" || echo "   No commits yet"
        fi
        
        # Build status
        echo ""
        echo -e "${BLUE}🏗️  Build Status:${NC}"
        if [ -d "dist" ] && [ "$(ls -A dist)" ]; then
            echo "   ✅ Build exists"
        else
            echo "   ❌ No build found - run './dev.sh build'"
        fi
        
        # Deployment links
        echo ""
        echo -e "${BLUE}🔗 Links:${NC}"
        echo "   GitHub: https://github.com/JordiPosthumus/jordisblog"
        
        if [ -f ".vercel/project.json" ]; then
            echo "   Vercel: https://vercel.com/dashboard/jordisblog"
        fi
        
        echo ""
        ;;
    help|*)
        show_help
        ;;
esac