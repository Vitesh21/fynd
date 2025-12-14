# Complete Deployment Guide - AI Feedback System

## Overview
Deploy your Flask backend to **Render** and both React dashboards to **Vercel** for free.

---

## Part 1: Prepare Your Code for Deployment

### Step 1: Create a GitHub Repository

1. **Go to** https://github.com/new
2. **Create a new repository** called `ai-feedback-system`
3. **Initialize locally:**

```powershell
cd C:\Users\91998\OneDrive\Desktop\lyz
git init
git add .
git commit -m "Initial commit: AI feedback system with Flask backend and React dashboards"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/ai-feedback-system.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your actual GitHub username.

---

## Part 2: Deploy Backend to Render

### Step 1: Create Render Account
1. Go to https://render.com
2. Click **Sign Up** → Choose **GitHub**
3. Authorize and complete signup

### Step 2: Deploy Backend
1. **Click** New + → **Web Service**
2. **Connect repository**: Select `ai-feedback-system`
3. **Fill in details:**
   - **Name:** `ai-feedback-backend`
   - **Environment:** `Python 3.11`
   - **Build Command:** `pip install -r backend/requirements_prod.txt`
   - **Start Command:** `cd backend && gunicorn -w 4 -b 0.0.0.0:$PORT app_prod:app`
   - **Plan:** Free (select "Free" tier)

4. **Environment Variables** → Click **Add Environment Variable**
   - **Key:** `GEMINI_API_KEY`
   - **Value:** `AIzaSyAYH2lCC6PiM3cA5LAO5DecorahRhZPuYI`

5. **Click Deploy**

### Step 3: Get Backend URL
- Wait for deployment (2-3 minutes)
- Copy your backend URL from the dashboard, e.g., `https://ai-feedback-backend.onrender.com`
- **Save this URL** - you'll need it for the dashboards

✅ **Backend Deployment Link:** `https://ai-feedback-backend.onrender.com`

---

## Part 3: Deploy User Dashboard to Vercel

### Step 1: Create Vercel Account
1. Go to https://vercel.com
2. Click **Sign Up** → Choose **GitHub**
3. Authorize and complete signup

### Step 2: Deploy User Dashboard
1. **Click** New Project
2. **Select** `ai-feedback-system` repository
3. **Configure Project:**
   - **Framework:** React
   - **Root Directory:** `user-dashboard`
   - **Build Command:** `npm run build`
   - **Output Directory:** `build`

4. **Environment Variables** → Click **Add**
   - **Name:** `REACT_APP_API_URL`
   - **Value:** `https://ai-feedback-backend.onrender.com` (your backend URL from Step 2)

5. **Click Deploy**

### Step 3: Get User Dashboard URL
- Wait for deployment (1-2 minutes)
- Your dashboard URL will be shown, e.g., `https://ai-feedback-user-dashboard.vercel.app`
- **Save this URL**

✅ **User Dashboard Link:** `https://ai-feedback-user-dashboard.vercel.app`

---

## Part 4: Deploy Admin Dashboard to Vercel (Separate Project)

### Step 1: Deploy Admin Dashboard as New Vercel Project

1. **On Vercel Dashboard** → Click **New Project**
2. **Select** `ai-feedback-system` repository (same repo)
3. **Configure Project:**
   - **Framework:** React
   - **Root Directory:** `admin-dashboard`
   - **Build Command:** `npm run build`
   - **Output Directory:** `build`

4. **Environment Variables** → Click **Add**
   - **Name:** `REACT_APP_API_URL`
   - **Value:** `https://ai-feedback-backend.onrender.com` (same backend URL)

5. **Click Deploy**

### Step 2: Get Admin Dashboard URL
- Wait for deployment (1-2 minutes)
- Your admin dashboard URL will be shown, e.g., `https://ai-feedback-admin-dashboard.vercel.app`
- **Save this URL**

✅ **Admin Dashboard Link:** `https://ai-feedback-admin-dashboard.vercel.app`

---

## Part 5: Test Your Deployment

### Test Backend
```powershell
# Open PowerShell and test backend health
Invoke-WebRequest -Uri "https://ai-feedback-backend.onrender.com/api/health"
```

Should return: `{"status":"healthy"}`

### Test User Dashboard
1. Go to `https://ai-feedback-user-dashboard.vercel.app`
2. Select 5 stars
3. Enter review: "Excellent product!"
4. Click Submit
5. Should display AI-generated response

### Test Admin Dashboard
1. Go to `https://ai-feedback-admin-dashboard.vercel.app`
2. Should show the submission you just made
3. Check that AI summary and actions are displayed

---

## Part 6: Automatic Deployments

Your GitHub Actions workflows are already configured to automatically deploy when you push to `main`:

```powershell
# To trigger deployment after making changes:
git add .
git commit -m "Update: [your changes]"
git push origin main
```

The system will automatically:
- Deploy backend to Render
- Deploy user dashboard to Vercel
- Deploy admin dashboard to Vercel

---

## Troubleshooting

### Backend Not Starting
- Check Render logs: https://dashboard.render.com
- Verify `GEMINI_API_KEY` is set correctly
- Check that `app_prod.py` exists in backend folder

### Dashboards Showing Blank
- Check browser console (F12) for errors
- Verify `REACT_APP_API_URL` is set correctly
- Check that backend URL is accessible

### No Data Showing in Admin Dashboard
- Wait 5 seconds for auto-refresh
- Submit a review from user dashboard first
- Check that both dashboards point to same backend URL

### Build Failures
1. Check logs in Render/Vercel dashboard
2. Ensure all dependencies in `package.json` are correct
3. Run locally: `npm install && npm start`

---

## Summary of Deployment Links

| Component | Platform | Link |
|-----------|----------|------|
| **Backend API** | Render | https://ai-feedback-backend.onrender.com |
| **User Dashboard** | Vercel | https://ai-feedback-user-dashboard.vercel.app |
| **Admin Dashboard** | Vercel | https://ai-feedback-admin-dashboard.vercel.app |

---

## Next Steps

1. **Share Links:** Give the user dashboard link to customers
2. **Monitor:** Check admin dashboard regularly for feedback
3. **Customize:** Modify colors, text, or AI prompts as needed
4. **Update:** Push changes to GitHub to auto-deploy

---

## Important Notes

- **Free Tier Limits:**
  - Render: Free tier sleeps after 15 min inactivity (wakes on request)
  - Vercel: Deployments are always active
  
- **Data Persistence:**
  - Data is stored on Render server in `submissions.json`
  - Persists across deployments
  - Cannot be accessed directly via URL (for security)

- **Email Notifications:**
  - Render and Vercel will email you on deployment status
  - GitHub Actions logs available at: https://github.com/YOUR_USERNAME/ai-feedback-system/actions

---

## Support & Docs

- **Render Docs:** https://render.com/docs
- **Vercel Docs:** https://vercel.com/docs
- **Flask/Gunicorn:** https://flask.palletsprojects.com/
- **React:** https://react.dev/

