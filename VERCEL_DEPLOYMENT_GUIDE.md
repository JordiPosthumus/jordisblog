# 🚀 Vercel Deployment Step-by-Step Guide

## The Process (2 Steps):

### **Step 1: Deploy Your Project First** ✅
First, Vercel needs to deploy your blog and give it a temporary URL.

### **Step 2: Add Your Custom Domain** 🌐
Then, you tell Vercel about your custom domain `jordisblog.com`.

---

## 📋 Detailed Steps:

### **Step 1: Deploy Project to Vercel**

1. **Go to [vercel.com](https://vercel.com)**
2. **Sign in** with your GitHub account
3. **Click "New Project"**
4. **Import from GitHub**: Find and select `jordisblog` repository
5. **Click "Deploy"**

**Vercel will now:**
- ✅ Install dependencies (`npm install`)
- ✅ Build your Astro blog 
- ✅ Give you a temporary URL like: `jordisblog-abcd1234.vercel.app`
- ⚡ Your site works at this URL immediately!

### **Step 2: Add Custom Domain**

After deployment completes:

1. **Go to your project dashboard** in Vercel
2. **Click "Settings"** (tab at the top)
3. **Click "Domains"** (in left sidebar)  
4. **Click "Add Domain"**
5. **Enter**: `jordisblog.com`
6. **Click "Add"**

**Vercel will show you:**
- ✅ Verification that DNS is working
- ⚠️ If not ready, it will tell you to wait for DNS propagation

---

## 🎯 What You'll See:

### **After Step 1 (Deployment):**
```
🌐 Your site is live at:
https://jordisblog-abcd1234.vercel.app
```

### **After Step 2 (Add Domain):**
```
✅ jordisblog.com 
   Status: Valid
   ⚡ Your site is live at:
   https://jordisblog.com (your custom domain)
```

---

## 🔍 Troubleshooting:

### **"Domain not found" or DNS errors?**
- Wait 1-2 hours after setting up Namecheap DNS
- Check your DNS at [whatsmydns.net](https://whatsmydns.net)
- Make sure you added the A records correctly in Namecheap

### **"Build failed"?**
- Check the build logs in Vercel dashboard
- Make sure all dependencies are correct (they should be)

---

## 📱 Expected Timeline:

1. **Deployment**: 2-3 minutes
2. **Temporary URL working**: Immediately after deployment  
3. **Custom domain working**: 15 minutes - 2 hours (after DNS propagation)

---

## 🎉 Success Checklist:

- [ ] Project deployed to Vercel
- [ ] Temporary URL working (like `jordisblog-abcd1234.vercel.app`)
- [ ] Custom domain added in Vercel settings
- [ ] Domain shows "Valid" status in Vercel
- [ ] Site works at https://jordisblog.com

**That's it! Your blog will be live and professional.**