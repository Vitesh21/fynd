# 🚀 Vercel Deployment Guide - AI Feedback System

## Backend Already Deployed ✅
**Backend URL:** https://fynd-1-g3ui.onrender.com

Now deploy both React dashboards to Vercel!

---

## Step 1: Deploy User Dashboard

### 1.1 Go to Vercel
- Visit https://vercel.com/dashboard
- Click **New Project**

### 1.2 Select Repository
- Select repository: **Vitesh21/fynd**
- Branch: **main**

### 1.3 Configure Project
- **Framework Preset:** React
- **Root Directory:** `user-dashboard`
- **Build Command:** `npm run build`
- **Output Directory:** `build`

### 1.4 Add Environment Variable
Click **Environment Variables** and add:
- **Name:** `REACT_APP_API_URL`
- **Value:** `https://fynd-1-g3ui.onrender.com`
- **Environments:** Production, Preview, Development

### 1.5 Deploy
Click **Deploy** and wait 1-2 minutes for completion.

### 1.6 Get Your User Dashboard URL
Once deployed, Vercel will show your URL, e.g.:
```
https://fynd-user-dashboard.vercel.app
```

✅ **Save your User Dashboard URL**

---

## Step 2: Deploy Admin Dashboard

### 2.1 Go to Vercel
- Click **New Project** again (you're adding a second project)

### 2.2 Select Repository
- Select repository: **Vitesh21/fynd** (same repo)
- Branch: **main**

### 2.3 Configure Project
- **Framework Preset:** React
- **Root Directory:** `admin-dashboard`
- **Build Command:** `npm run build`
- **Output Directory:** `build`

### 2.4 Add Environment Variable
Click **Environment Variables** and add:
- **Name:** `REACT_APP_API_URL`
- **Value:** `https://fynd-1-g3ui.onrender.com` (same backend URL)
- **Environments:** Production, Preview, Development

### 2.5 Deploy
Click **Deploy** and wait 1-2 minutes for completion.

### 2.6 Get Your Admin Dashboard URL
Once deployed, Vercel will show your URL, e.g.:
```
https://fynd-admin-dashboard.vercel.app
```

✅ **Save your Admin Dashboard URL**

---

## Step 3: Test Everything

### Test Backend
Open in browser or PowerShell:
```powershell
Invoke-WebRequest -Uri "https://fynd-1-g3ui.onrender.com/api/health"
```
Should return: `{"status":"healthy"}`

### Test User Dashboard
1. Open: **https://fynd-user-dashboard.vercel.app**
2. Select **5 stars**
3. Type: "Excellent app, very helpful!"
4. Click **Submit**
5. ✅ Should see AI-generated response

### Test Admin Dashboard
1. Open: **https://fynd-admin-dashboard.vercel.app**
2. Should see the submission from User Dashboard
3. Check that:
   - Review text is displayed ✓
   - AI Summary is shown ✓
   - Recommended Actions are listed ✓
4. Wait 5 seconds - auto-refresh should trigger

---

## Your Deployment Links

| Service | URL |
|---------|-----|
| Backend API | https://fynd-1-g3ui.onrender.com |
| User Dashboard | https://fynd-user-dashboard.vercel.app |
| Admin Dashboard | https://fynd-admin-dashboard.vercel.app |

---

## Automatic Updates

Every time you push to GitHub:
```powershell
git add .
git commit -m "Your changes"
git push origin main
```

Both dashboards automatically redeploy on Vercel!

For the backend, Render watches your GitHub too - any changes to the `backend/` folder trigger a redeploy.

---

## Troubleshooting

### Dashboards show blank screen
- Open browser console (F12)
- Check for errors mentioning API URL
- Make sure `REACT_APP_API_URL` is set correctly
- Clear browser cache (Ctrl+Shift+Delete)

### Admin Dashboard shows no data
- Submit a review in User Dashboard first
- Wait 5+ seconds for auto-refresh
- Check that both dashboards point to same backend URL

### Backend returns 404 errors
- Check that backend URL is: `https://fynd-1-g3ui.onrender.com`
- Verify GEMINI_API_KEY is set in Render environment

### Still not working?
1. Check Vercel logs: https://vercel.com/dashboard
2. Check Render logs: https://dashboard.render.com
3. Open browser console (F12) for frontend errors

---

## Done! 🎉

Your AI Feedback System is now live with:
- ✅ Backend running on Render
- ✅ User Dashboard on Vercel
- ✅ Admin Dashboard on Vercel
- ✅ Automatic deployments on every GitHub push

Share the **User Dashboard URL** with customers to collect feedback!

