# 🚀 Jordi's Blog - Deployment Scripts

This folder contains automated deployment and development scripts for your blog.

## 📁 Available Scripts

### Development Helper
```bash
./dev.sh [command]
```

**Commands:**
- `install` - Install dependencies  
- `dev` - Start development server (localhost:4321)
- `build` - Build for production
- `preview` - Preview build locally
- `clean` - Clean dist and cache files  
- `deploy` - Interactive deployment 
- `quick-deploy` - Fast push & deploy
- `status` - Show git/deployment status

### Full Deployment Script  
```bash
./deploy.sh
```

**Features:**
- ✅ Checks Git status 
- ✅ Optional local build testing
- ✅ Commits changes (with prompts)
- ✅ Pushes to GitHub  
- ✅ Triggers Vercel deployment
- ✅ Shows deployment status

### Quick Deployment Script
```bash
./deploy-quick.sh
```

**Features:**
- ⚡ Auto-commits with timestamp
- 🚀 Pushes immediately  
- 📊 Minimal prompts

## 🔄 Normal Deployment Protocol

Here's the standard workflow for deploying your blog:

### Step 1: Development
```bash
# Make changes to content/code
./dev.sh dev          # Test locally at localhost:4321  
# Edit files...
```

### Step 2: Deploy
```bash
# Option A: Interactive (recommended)
./deploy.sh

# Option B: Quick push  
npm run deploy-quick
```

### Step 3: Monitor
- Check [Vercel Dashboard](https://vercel.com/dashboard/jordisblog)
- Wait 1-2 minutes for deployment
- Test your live site

## 🎯 NPM Script Shortcuts

These are automatically available:

```bash
npm run dev           # Start development server
npm run build         # Build for production  
npm run preview       # Preview build locally
npm run deploy        # Interactive deployment 
npm run deploy-quick  # Quick push & deploy
```

## 🔧 Troubleshooting

### Script Not Executable?
```bash
chmod +x *.sh
```

### Permission Denied?  
```bash
sudo chmod 755 *.sh
```

### Need GitHub Authentication?
- Use Personal Access Token instead of password
- Or use SSH keys for seamless authentication

## 📋 Pre-deployment Checklist

1. ✅ Changes tested locally
2. ✅ All files committed to Git  
3. ✅ Build succeeds without errors
4. ✅ Ready to push to production

## 🎉 Success Indicators

After deployment, you should see:
- ✅ "Pushed to GitHub successfully" message
- ✅ Vercel build log showing successful compilation  
- ✅ All new content visible on live site
- ✅ No build errors in Vercel dashboard

---

**Tip:** Start with `./dev.sh status` to see current project state before deploying!