# Quick Deployment Script - AI Feedback System (Windows)
# This script helps you set up GitHub, Render, and Vercel in sequence

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "AI Feedback System Deployment Helper" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: GitHub
Write-Host "Step 1: Push Code to GitHub" -ForegroundColor Yellow
Write-Host "===========================" -ForegroundColor Yellow
$github_username = Read-Host "Enter your GitHub username"
$repo_name = Read-Host "Enter repository name (default: ai-feedback-system)"
if ($repo_name -eq "") { $repo_name = "ai-feedback-system" }

Write-Host "Initializing Git repository..." -ForegroundColor Green
try {
    git init
    git add .
    git commit -m "Initial commit: AI feedback system"
    git branch -M main
    git remote add origin "https://github.com/$github_username/$repo_name.git"
    git push -u origin main
    Write-Host "✅ Code pushed to GitHub!" -ForegroundColor Green
} catch {
    Write-Host "❌ Git error: $_" -ForegroundColor Red
}
Write-Host ""

# Step 2: Render Deployment Instructions
Write-Host "Step 2: Deploy Backend to Render" -ForegroundColor Yellow
Write-Host "=================================" -ForegroundColor Yellow
Write-Host "1. Go to https://render.com" -ForegroundColor Cyan
Write-Host "2. Sign up with GitHub" -ForegroundColor Cyan
Write-Host "3. Click 'New +' → 'Web Service'" -ForegroundColor Cyan
Write-Host "4. Select your repository: $repo_name" -ForegroundColor Cyan
Write-Host ""
Write-Host "Configuration:" -ForegroundColor White
Write-Host "  - Name: ai-feedback-backend" -ForegroundColor White
Write-Host "  - Environment: Python 3.11" -ForegroundColor White
Write-Host "  - Build Command: pip install -r backend/requirements_prod.txt" -ForegroundColor White
Write-Host "  - Start Command: cd backend && gunicorn -w 4 -b 0.0.0.0:`$PORT app_prod:app" -ForegroundColor White
Write-Host "  - Plan: Free" -ForegroundColor White
Write-Host ""
Write-Host "Environment Variables:" -ForegroundColor White
Write-Host "  - GEMINI_API_KEY: AIzaSyAYH2lCC6PiM3cA5LAO5DecorahRhZPuYI" -ForegroundColor White
Write-Host ""
Read-Host "Press Enter after creating backend on Render" -ForegroundColor Cyan
$backend_url = Read-Host "Enter your Render Backend URL (e.g., https://ai-feedback-backend.onrender.com)"

Write-Host "✅ Backend URL saved: $backend_url" -ForegroundColor Green
Write-Host ""

# Step 3: Vercel Deployment Instructions
Write-Host "Step 3: Deploy Dashboards to Vercel" -ForegroundColor Yellow
Write-Host "====================================" -ForegroundColor Yellow
Write-Host "1. Go to https://vercel.com" -ForegroundColor Cyan
Write-Host "2. Sign up with GitHub" -ForegroundColor Cyan
Write-Host "3. Click 'New Project'" -ForegroundColor Cyan
Write-Host "4. Select repository: $repo_name" -ForegroundColor Cyan
Write-Host ""
Write-Host "For User Dashboard:" -ForegroundColor White
Write-Host "  - Root Directory: user-dashboard" -ForegroundColor White
Write-Host "  - Environment Variable:" -ForegroundColor White
Write-Host "    - REACT_APP_API_URL: $backend_url" -ForegroundColor White
Write-Host ""
Write-Host "For Admin Dashboard (separate project):" -ForegroundColor White
Write-Host "  - Root Directory: admin-dashboard" -ForegroundColor White
Write-Host "  - Environment Variable:" -ForegroundColor White
Write-Host "    - REACT_APP_API_URL: $backend_url" -ForegroundColor White
Write-Host ""
Read-Host "Press Enter after deploying both dashboards to Vercel" -ForegroundColor Cyan
$user_dashboard_url = Read-Host "Enter User Dashboard URL (e.g., https://ai-feedback-user-dashboard.vercel.app)"
$admin_dashboard_url = Read-Host "Enter Admin Dashboard URL (e.g., https://ai-feedback-admin-dashboard.vercel.app)"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Your Deployment Links:" -ForegroundColor Cyan
Write-Host "Backend:        $backend_url" -ForegroundColor White
Write-Host "User Dashboard: $user_dashboard_url" -ForegroundColor White
Write-Host "Admin Dashboard: $admin_dashboard_url" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Test the User Dashboard: $user_dashboard_url" -ForegroundColor White
Write-Host "2. Submit a review" -ForegroundColor White
Write-Host "3. Check Admin Dashboard: $admin_dashboard_url" -ForegroundColor White
Write-Host "4. Share User Dashboard link with customers" -ForegroundColor White
Write-Host ""
