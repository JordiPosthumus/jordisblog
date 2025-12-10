# Jordi's Blog - Financial Analysis & Market Insights

A modern Astro-based blog featuring comprehensive financial analysis, with a focus on precious metals markets and investment research.

## Features

- 🚀 **Fast & Modern**: Built with Astro for optimal performance
- 📱 **Responsive Design**: Beautiful, mobile-first design with Tailwind CSS  
- 🔍 **SEO Optimized**: Complete meta tags and sitemap generation
- 📊 **Rich Content**: Support for charts, images, and interactive analysis
- ⚡ **Static Generation**: Lightning-fast loading with pre-built pages

## Current Content

### Featured Analysis: The Great Silver Squeeze
Comprehensive analysis revealing how silver shattered the $60 barrier for the first time in history:
- 338% year-to-date gain to $61.69/oz
- Supply deficit of 820 million ounces  
- COMEX inventory crisis documentation
- Industrial demand revolution breakdown
- Investment strategy recommendations

## Development

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production  
npm run build

# Preview production build
npm run preview
```

## Deployment to Vercel

### Option 1: Automatic Deployment (Recommended)

1. **Push to GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial blog setup with silver analysis"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/jordisblog.git
   git push -u origin main
   ```

2. **Deploy via Vercel**
   - Go to [vercel.com](https://vercel.com)
   - Sign in with GitHub
   - Click "New Project" 
   - Import your `jordisblog` repository
   - Vercel will auto-detect it's an Astro project

3. **Custom Domain Setup**
   - In Vercel dashboard, go to your project → Settings → Domains
   - Add `jordisblog.com` as custom domain
   - Follow DNS setup instructions

### Option 2: Vercel CLI (Alternative)

```bash
# Install Vercel CLI
npm i -g vercel

# Login to Vercel
vercel login

# Deploy (from project root)
vercel --prod
```

### DNS Configuration for Namecheap

Add these records to your Namecheap domain:

```
Type: A
Host: @  
Value: 76.76.21.21

Type: CNAME
Host: www
Value: cname.vercel-dns.com
```

## Project Structure

```
jordisblog/
├── src/                    # Source files
│   ├── layouts/           # Layout components  
│   │   ├── Layout.astro   # Main site layout
│   │   └── BlogPost.astro # Blog post layout
│   ├── pages/             # Site pages
│   │   ├── index.astro    # Homepage  
│   │   ├── about.astro    # About page
│   │   └── posts/         # Blog posts
│   └── styles/            # Global styles
├── public/                # Static assets
│   ├── charts/            # Analysis images  
│   └── favicon.svg        # Site icon
├── dist/                  # Built files (auto-generated)
└── astro.config.mjs       # Astro configuration
```

## Adding New Posts

Create new markdown files in `src/pages/posts/`:

```markdown
---
title: "Your Post Title"
description: "Post description for SEO"  
pubDate: "2025-12-10"
---

# Your Content Here

Your blog post content...
```

## Customization

- **Colors**: Modify Tailwind config in `tailwind.config.js`
- **Layouts**: Edit components in `src/layouts/`
- **Content**: Add posts in `src/pages/posts/` 
- **Styling**: Update global styles or add custom CSS

## Performance Optimizations

✅ Static page generation  
✅ Image optimization ready  
✅ SEO meta tags complete  
✅ Sitemap auto-generation  
✅ Mobile-first responsive design  

---

**Live Site**: https://jordisblog.com (after deployment)  
**Author**: Jordi Posthumus | Financial Analysis & Market Research
