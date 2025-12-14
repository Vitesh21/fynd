#!/bin/bash
# Quick Deployment Script - AI Feedback System
# This script helps you set up GitHub, Render, and Vercel in sequence

echo "========================================"
echo "AI Feedback System Deployment Helper"
echo "========================================"
echo ""

# Step 1: GitHub
echo "Step 1: Push to GitHub"
echo "====================="
read -p "Enter your GitHub username: " github_username
read -p "Enter your GitHub personal access token: " github_token
read -p "Enter repository name (default: ai-feedback-system): " repo_name
repo_name=${repo_name:-ai-feedback-system}

echo "Initializing Git repository..."
git init
git add .
git commit -m "Initial commit: AI feedback system"
git branch -M main
git remote add origin "https://github.com/$github_username/$repo_name.git"
git push -u origin main

echo "✅ Code pushed to GitHub!"
echo ""

# Step 2: Render Deployment Instructions
echo "Step 2: Deploy Backend to Render"
echo "================================"
echo "1. Go to https://render.com"
echo "2. Sign up with GitHub"
echo "3. Click 'New +' → 'Web Service'"
echo "4. Select your repository: $repo_name"
echo ""
echo "Configuration:"
echo "  - Name: ai-feedback-backend"
echo "  - Environment: Python 3.11"
echo "  - Build Command: pip install -r backend/requirements_prod.txt"
echo "  - Start Command: cd backend && gunicorn -w 4 -b 0.0.0.0:\$PORT app_prod:app"
echo "  - Plan: Free"
echo ""
echo "Environment Variables:"
echo "  - GEMINI_API_KEY: AIzaSyAYH2lCC6PiM3cA5LAO5DecorahRhZPuYI"
echo ""
read -p "Press Enter after creating backend on Render..."
read -p "Enter your Render Backend URL (e.g., https://ai-feedback-backend.onrender.com): " backend_url

echo "✅ Backend URL saved: $backend_url"
echo ""

# Step 3: Vercel Deployment Instructions
echo "Step 3: Deploy Dashboards to Vercel"
echo "===================================="
echo "1. Go to https://vercel.com"
echo "2. Sign up with GitHub"
echo "3. Click 'New Project'"
echo "4. Select repository: $repo_name"
echo ""
echo "For User Dashboard:"
echo "  - Root Directory: user-dashboard"
echo "  - Environment Variable:"
echo "    - REACT_APP_API_URL: $backend_url"
echo ""
echo "For Admin Dashboard (separate project):"
echo "  - Root Directory: admin-dashboard"
echo "  - Environment Variable:"
echo "    - REACT_APP_API_URL: $backend_url"
echo ""
read -p "Press Enter after deploying both dashboards to Vercel..."
read -p "Enter User Dashboard URL (e.g., https://ai-feedback-user-dashboard.vercel.app): " user_dashboard_url
read -p "Enter Admin Dashboard URL (e.g., https://ai-feedback-admin-dashboard.vercel.app): " admin_dashboard_url

echo ""
echo "========================================"
echo "✅ DEPLOYMENT COMPLETE!"
echo "========================================"
echo ""
echo "Your Deployment Links:"
echo "Backend:        $backend_url"
echo "User Dashboard: $user_dashboard_url"
echo "Admin Dashboard: $admin_dashboard_url"
echo ""
echo "Next Steps:"
echo "1. Test the User Dashboard: $user_dashboard_url"
echo "2. Submit a review"
echo "3. Check Admin Dashboard: $admin_dashboard_url"
echo "4. Share User Dashboard link with customers"
echo ""
