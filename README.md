# AI Feedback System - Two-Dashboard Application

A simple web application with two dashboards for collecting and managing user feedback using AI-powered responses.

## Features

### User Dashboard (Public)
- Select star rating (1-5 stars)
- Write review text
- Submit feedback
- Receive AI-generated response
- View summary and recommended actions

### Admin Dashboard (Internal)
- View all submissions in real-time
- See user ratings and reviews
- View AI-generated summaries
- Check recommended actions
- Filter submissions by rating
- Analytics overview (total reviews, average rating, rating distribution)
- Auto-refresh capability

## Tech Stack

- **Backend**: Flask (Python)
- **Frontend**: React
- **AI/LLM**: Google Gemini API
- **Storage**: JSON file
- **Deployment**: Vercel (frontend), Render/Railway (backend)

## Project Structure

```
lyz/
├── backend/
│   ├── app.py              # Flask application (development)
│   ├── app_prod.py         # Flask application (production)
│   ├── requirements.txt     # Python dependencies
│   ├── requirements_prod.txt # Production dependencies
│   ├── Dockerfile          # Docker configuration
│   ├── Procfile            # Heroku/Render configuration
│   └── submissions.json    # Data storage
├── user-dashboard/
│   ├── package.json
│   ├── public/
│   ├── src/
│   └── vercel.json
└── admin-dashboard/
    ├── package.json
    ├── public/
    ├── src/
    └── vercel.json
```

## Local Development

### Backend Setup

1. Install Python dependencies:
```bash
cd backend
pip install -r requirements.txt
```

2. Run the Flask server:
```bash
python app.py
```

The backend will run on `http://localhost:5000`

### User Dashboard Setup

1. Install dependencies:
```bash
cd user-dashboard
npm install
```

2. Create `.env.local`:
```
REACT_APP_API_URL=http://localhost:5000
```

3. Start the development server:
```bash
npm start
```

The dashboard will run on `http://localhost:3000`

### Admin Dashboard Setup

1. Install dependencies:
```bash
cd admin-dashboard
npm install
```

2. Create `.env.local`:
```
REACT_APP_API_URL=http://localhost:5000
```

3. Start the development server:
```bash
npm start
```

The dashboard will run on `http://localhost:3001` (or another port if 3000 is taken)

## API Endpoints

### Submit Review
- **POST** `/api/submit-review`
- Body: `{ rating: number (1-5), review: string }`
- Returns: Submission with AI-generated response, summary, and actions

### Get All Submissions
- **GET** `/api/submissions`
- Returns: Array of all submissions

### Get Specific Submission
- **GET** `/api/submissions/:id`
- Returns: Specific submission object

### Get Analytics
- **GET** `/api/analytics`
- Returns: Total reviews, average rating, rating distribution

### Health Check
- **GET** `/api/health`
- Returns: `{ status: "healthy" }`

## Deployment

### Backend Deployment (Render)

1. Push your code to GitHub
2. Create a new Web Service on Render
3. Connect your GitHub repository
4. Set environment variables:
   - `GEMINI_API_KEY`: Your Gemini API key
5. Deploy

### User Dashboard Deployment (Vercel)

1. Push your code to GitHub
2. Import project on Vercel
3. Add environment variable:
   - `REACT_APP_API_URL`: Your backend URL from Render
4. Deploy

### Admin Dashboard Deployment (Vercel)

1. Push your code to GitHub
2. Import project on Vercel as separate project
3. Add environment variable:
   - `REACT_APP_API_URL`: Your backend URL from Render
4. Deploy

## Environment Variables

### Backend
- `GEMINI_API_KEY`: Google Gemini API key
- `PORT`: Port to run on (default: 5000)

### Frontend
- `REACT_APP_API_URL`: Backend API URL

## Notes

- The system stores submissions in a JSON file (`submissions.json`)
- AI responses are generated using Google Gemini API
- Both dashboards share the same data source
- Admin dashboard has auto-refresh feature (every 5 seconds by default)
- All timestamps are in ISO format

## File Structure Example

### submissions.json
```json
[
  {
    "id": "2024-01-15T10:30:00.000Z",
    "rating": 5,
    "review": "Great service!",
    "response": "Thank you for the positive feedback...",
    "summary": "User appreciated the service quality",
    "actions": ["Acknowledge positive feedback", "Share with team"],
    "timestamp": "2024-01-15T10:30:00.000Z"
  }
]
```

## License

MIT
