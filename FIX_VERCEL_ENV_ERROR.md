# Fix Vercel Environment Variable Error

## Problem
Vercel is still trying to use a Secret called "user-dashboard-backend" which doesn't exist.

## Solution

### For User Dashboard:

1. **Go to:** https://vercel.com/dashboard
2. **Select:** `fynd` project (user-dashboard)
3. **Go to:** Settings → Environment Variables
4. **Find:** Any entry showing `REACT_APP_API_URL` with a lock icon 🔒
5. **Delete it completely** - click the X or trash icon
6. **Wait 2 seconds**
7. **Add New Environment Variable - DO THIS CAREFULLY:**
   - **Name field:** Type exactly: `REACT_APP_API_URL`
   - **Value field:** Type exactly: `https://fynd-1-g3ui.onrender.com`
   - **DO NOT click any "Add Secret" button**
   - **Click the blue "Save" button** (not "Add as Secret")
   - **Environments to select:** Check all three boxes
     - ☑ Production
     - ☑ Preview  
     - ☑ Development
   - **Click Save**

8. **Redeploy:**
   - Go to **Deployments** tab
   - Find the latest deployment (should show as failed)
   - Click on it
   - Click **Redeploy** button
   - Wait 2-3 minutes for build

---

### For Admin Dashboard:

Repeat the exact same steps above but for the admin-dashboard project.

---

## Important Notes

- ❌ **Do NOT use the "Add Secret" feature**
- ✅ **Just use regular "Save" button for plain text values**
- Make sure to **check all 3 environment checkboxes**
- After saving, you MUST click **Redeploy** for changes to take effect

---

## If It Still Doesn't Work

Try this nuclear option:

1. Go to project Settings → Environment Variables
2. **Delete ALL environment variables** (even if there are multiple REACT_APP_API_URL entries)
3. Wait 5 seconds
4. Add it fresh:
   - Name: `REACT_APP_API_URL`
   - Value: `https://fynd-1-g3ui.onrender.com`
   - Check all 3 boxes
   - Click **Save**
5. Go to Deployments and click **Redeploy**

---

## Test After Deployment

Once the redeploy completes successfully, test:

```powershell
# User Dashboard
Invoke-WebRequest -Uri "https://fynd-user-XXX.vercel.app"

# Admin Dashboard  
Invoke-WebRequest -Uri "https://fynd-admin-XXX.vercel.app"
```

Both should load without errors.

