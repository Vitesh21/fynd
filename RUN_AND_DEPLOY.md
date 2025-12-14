# How to Run & Deploy the AI Feedback System

## Quick Start: Run Locally (5 Minutes)

### Prerequisites
- Python 3.8+
- Node.js 14+
- npm

### Step 1: Start Backend

```bash
cd backend
pip install -r requirements.txt
python app.py
```

Backend runs on: **http://localhost:5000**

### Step 2: Start User Dashboard (New Terminal)

```bash
cd user-dashboard
npm install
npm start
```

Opens automatically on: **http://localhost:3000**

### Step 3: Start Admin Dashboard (New Terminal)

```bash
cd admin-dashboard
npm install
npm start
```

Opens on: **http://localhost:3001**

### Step 4: Test It

1. Go to http://localhost:3000 (User Dashboard)
2. Select a star rating
3. Write a test review
4. Click "Submit Review"
5. Go to http://localhost:3001 (Admin Dashboard)
6. Watch your submission appear in real-time!

---

## Deploy to Cloud (20 Minutes)

### Prerequisites
- GitHub account
- Render account (backend)
- Vercel account (frontend)

### STEP 1: Create GitHub Repository

```bash
cd c:\Users\91998\OneDrive\Desktop\lyz
git init
git add .
git commit -m "Initial commit: AI Feedback System"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/ai-feedback-system.git
git push -u origin main
```

### STEP 2: Deploy Backend to Render

1. Go to [render.com](https://render.com)
2. Sign up with GitHub
3. Click "New +" → "Web Service"
4. Select your GitHub repository
5. Configure:
   - **Name**: `ai-feedback-backend`
   - **Environment**: `Python 3`
   - **Build Command**: `pip install -r requirements_prod.txt`
   - **Start Command**: `gunicorn app_prod:app`
   - **Region**: Select closest to you

6. **Add Environment Variable**:
   - Key: `GEMINI_API_KEY`
   - Value: `AIzaSyAYH2lCC6PiM3cA5LAO5DecorahRhZPuYI`

7. Click "Deploy"
8. Wait for deployment to complete
9. Copy the URL (e.g., `https://ai-feedback-backend.onrender.com`)

**Save this URL** - you'll need it for frontend deployments.

### STEP 3: Deploy User Dashboard to Vercel

1. Go to [vercel.com](https://vercel.com)
2. Sign up with GitHub
3. Click "New Project"
4. Select your GitHub repository
5. Configure:
   - **Framework**: React
   - **Root Directory**: `user-dashboard`

6. **Add Environment Variable**:
   - Name: `REACT_APP_API_URL`
   - Value: `https://ai-feedback-backend.onrender.com` (your backend URL from Step 2)

7. Click "Deploy"
8. Wait for completion
9. Copy your deployment URL (e.g., `https://user-dashboard.vercel.app`)

### STEP 4: Deploy Admin Dashboard to Vercel

1. Go to [vercel.com](https://vercel.com)
2. Click "New Project"
3. Select the same GitHub repository
4. Configure:
   - **Framework**: React
   - **Root Directory**: `admin-dashboard`

5. **Add Environment Variable**:
   - Name: `REACT_APP_API_URL`
   - Value: `https://ai-feedback-backend.onrender.com` (same backend URL)

6. Click "Deploy"
7. Wait for completion
8. Copy your deployment URL (e.g., `https://admin-dashboard.vercel.app`)

---

## Verify Deployment Works

### Test User Dashboard
1. Open your User Dashboard URL
2. Submit a test review
3. You should see success message with AI response

### Test Admin Dashboard
1. Open your Admin Dashboard URL
2. You should see your test submission
3. Click auto-refresh toggle to enable live updates

### Test Backend API
```bash
curl https://ai-feedback-backend.onrender.com/api/health
```

Should return: `{"status":"healthy"}`

---

## Your Final URLs

After deployment, you'll have:

- **User Dashboard**: `https://user-dashboard.vercel.app`
- **Admin Dashboard**: `https://admin-dashboard.vercel.app`
- **Backend API**: `https://ai-feedback-backend.onrender.com`

Share the **User Dashboard URL** with your users!

---

## Troubleshooting

### Backend won't start locally
```bash
# Check if port 5000 is in use
netstat -ano | findstr :5000

# Or use different port
python app.py --port 5001
```

### CORS errors in browser
- Make sure backend is running
- Check frontend API URL matches backend URL exactly
- Check Network tab in browser DevTools

### Deployment fails on Vercel
- Check environment variables are set correctly
- Verify backend URL is accessible
- Check build logs for errors

### Deployment fails on Render
- Check Gemini API key is valid
- Verify requirements_prod.txt has all dependencies
- Check logs tab for error details

### Submissions not appearing in Admin Dashboard
1. Submit a review in User Dashboard first
2. Check backend logs for errors
3. Verify both dashboards use same backend URL
4. Try manual refresh button

---

## Making Changes After Deployment

### Update Backend
1. Make changes to `backend/app_prod.py`
2. Commit and push to GitHub
3. Render auto-deploys from main branch

### Update User Dashboard
1. Make changes to `user-dashboard/src/App.js` (or CSS)
2. Commit and push to GitHub
3. Vercel auto-deploys from main branch

### Update Admin Dashboard
1. Make changes to `admin-dashboard/src/App.js` (or CSS)
2. Commit and push to GitHub
3. Vercel auto-deploys from main branch

---

## Local Development Tips

### Use .env files for configuration

**backend/.env**:
```
GEMINI_API_KEY=AIzaSyAYH2lCC6PiM3cA5LAO5DecorahRhZPuYI
FLASK_ENV=development
FLASK_DEBUG=True
PORT=5000
```

**user-dashboard/.env.local**:
```
REACT_APP_API_URL=http://localhost:5000
```

**admin-dashboard/.env.local**:
```
REACT_APP_API_URL=http://localhost:5000
```

### View backend logs
```bash
cd backend
python app.py
# Logs print to console
```

### View frontend build errors
```bash
cd user-dashboard
npm start
# Build errors shown in terminal
```

### Test API endpoints manually
```bash
# Submit review
curl -X POST http://localhost:5000/api/submit-review \
  -H "Content-Type: application/json" \
  -d '{"rating": 5, "review": "Great!"}'

# Get all submissions
curl http://localhost:5000/api/submissions

# Get analytics
curl http://localhost:5000/api/analytics
```

---

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| "Cannot connect to backend" | Check backend is running on http://localhost:5000 |
| "Module not found" errors | Run `npm install` in the dashboard folder |
| "CORS error" in browser | Verify backend has CORS enabled (it does by default) |
| Vercel deployment fails | Check environment variables in Vercel dashboard |
| Render deployment fails | Check Gemini API key and dependencies |
| No submissions showing | Make sure to submit from User Dashboard first |

---

## Next Steps

1. **Test locally** - Follow the Quick Start above
2. **Deploy to cloud** - Follow the Deploy section
3. **Customize** - Modify colors, prompts, or functionality
4. **Monitor** - Set up alerts in Render/Vercel dashboards
5. **Iterate** - Make improvements based on user feedback

**You're ready to go! Start with the Quick Start section above.** 🚀
