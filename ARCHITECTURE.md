# System Architecture

## High-Level Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         Internet / Cloud                          │
└─────────────────────────────────────────────────────────────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    │               │               │
                    ▼               ▼               ▼
          ┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐
          │   User Dashboard │ │  Admin Dashboard │ │  Backend API     │
          │   (Vercel)       │ │   (Vercel)       │ │  (Render)        │
          │   - React        │ │   - React        │ │  - Flask         │
          │   - Public       │ │   - Internal     │ │  - Python        │
          └────────┬─────────┘ └────────┬─────────┘ └────────┬────────┘
                   │                    │                     │
                   └────────────────────┼─────────────────────┘
                                        │
                              REST API (HTTP/HTTPS)
                                        │
                                        ▼
                         ┌──────────────────────────┐
                         │   Flask Backend          │
                         │                          │
                         │  • Submit Review         │
                         │  • Get Submissions       │
                         │  • Get Analytics         │
                         │  • Generate AI Response  │
                         └──────────────┬───────────┘
                                        │
                         ┌──────────────┴───────────┐
                         │                          │
                         ▼                          ▼
                ┌─────────────────────┐  ┌──────────────────────┐
                │  Gemini AI API      │  │  Data Storage        │
                │  (Google Cloud)     │  │  (JSON File)         │
                │                     │  │                      │
                │  • Generate         │  │  • Submissions       │
                │    responses        │  │  • Ratings           │
                │  • Summarize        │  │  • Reviews           │
                │  • Generate actions │  │  • AI Responses      │
                └─────────────────────┘  └──────────────────────┘
```

## Component Details

### 1. User Dashboard (Frontend)
- **Technology**: React
- **Deployment**: Vercel
- **Features**:
  - Star rating selector (1-5 stars)
  - Review textarea
  - Submit button
  - Success screen with AI response
  - Real-time feedback

### 2. Admin Dashboard (Frontend)
- **Technology**: React
- **Deployment**: Vercel (separate project)
- **Features**:
  - Real-time submission list
  - Auto-refresh capability (5-second intervals)
  - Filter by rating
  - Analytics section (total, average, distribution)
  - Display of:
    - User reviews
    - AI summaries
    - Recommended actions
    - Timestamps

### 3. Backend API
- **Technology**: Flask (Python)
- **Deployment**: Render
- **Features**:
  - REST API endpoints
  - Gemini API integration
  - JSON file storage
  - CORS enabled
  - Error handling
  - Analytics calculation

### 4. Data Storage
- **Format**: JSON
- **Location**: `backend/submissions.json`
- **Structure**:
  ```json
  [
    {
      "id": "2024-01-15T10:30:00.000Z",
      "rating": 5,
      "review": "Great service!",
      "response": "Thank you for your feedback...",
      "summary": "User appreciated service quality",
      "actions": ["Acknowledge positive feedback"],
      "timestamp": "2024-01-15T10:30:00.000Z"
    }
  ]
  ```

### 5. AI Integration
- **Service**: Google Gemini API
- **Model**: gemini-pro
- **Tasks**:
  - Generate user-facing responses
  - Create review summaries
  - Suggest recommended actions
- **Prompt Engineering**: Dynamic prompts based on rating and review

## API Endpoints

### POST /api/submit-review
- **Purpose**: Submit a new review
- **Request**:
  ```json
  {
    "rating": 5,
    "review": "Great product!"
  }
  ```
- **Response**:
  ```json
  {
    "success": true,
    "submission": {
      "id": "...",
      "rating": 5,
      "review": "...",
      "response": "...",
      "summary": "...",
      "actions": [...],
      "timestamp": "..."
    }
  }
  ```

### GET /api/submissions
- **Purpose**: Get all submissions
- **Response**: Array of submission objects

### GET /api/submissions/:id
- **Purpose**: Get specific submission
- **Response**: Single submission object

### GET /api/analytics
- **Purpose**: Get analytics data
- **Response**:
  ```json
  {
    "total_reviews": 10,
    "average_rating": 4.5,
    "rating_distribution": {
      "1": 0,
      "2": 1,
      "3": 1,
      "4": 3,
      "5": 5
    }
  }
  ```

### GET /api/health
- **Purpose**: Health check
- **Response**: `{"status": "healthy"}`

## Data Flow

### Submission Flow

```
User Dashboard
    │
    ├─ User selects rating
    ├─ User writes review
    └─ User clicks submit
       │
       ▼
   HTTP POST /api/submit-review
       │
       ▼
   Backend API
    │
    ├─ Validate input
    ├─ Call Gemini API for:
    │  ├─ User-facing response
    │  ├─ Review summary
    │  └─ Recommended actions
    │
    ├─ Load existing submissions
    ├─ Add new submission
    └─ Save to submissions.json
       │
       ▼
   Return response to User Dashboard
       │
       ▼
   Display success screen with AI response
```

### Admin Dashboard Data Flow

```
Admin Dashboard (periodically or on demand)
    │
    ├─ HTTP GET /api/submissions
    ├─ HTTP GET /api/analytics
    │
    ▼
Backend API
    │
    ├─ Load submissions.json
    ├─ Calculate analytics
    │
    ▼
Return data to Admin Dashboard
    │
    ▼
Display submissions and analytics
```

## Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| Frontend (User) | React, JavaScript, CSS | User interface for feedback submission |
| Frontend (Admin) | React, JavaScript, CSS | Admin interface for monitoring |
| Backend | Flask, Python | REST API server |
| AI/LLM | Gemini API | Generate responses and summaries |
| Database | JSON file | Persistent storage |
| Deployment | Vercel (Frontend), Render (Backend) | Cloud hosting |
| Communication | REST API, HTTP/HTTPS, CORS | Client-Server interaction |

## Security Considerations

1. **API Keys**: Gemini API key stored in environment variables
2. **CORS**: Enabled for frontend domains
3. **Input Validation**: All inputs validated on backend
4. **Error Handling**: Graceful error responses
5. **No Authentication**: Public submissions (optional to add)

## Scalability

### Current Bottlenecks
1. **JSON File Storage**: Works for up to 10k submissions
2. **Gemini API Rate Limits**: Depends on quota
3. **Render Free Tier**: May sleep after inactivity

### For Production Scaling
1. **Database**: Migrate from JSON to PostgreSQL/MongoDB
2. **Caching**: Add Redis for analytics
3. **Queue**: Add Celery for async AI processing
4. **CDN**: Use Vercel's global CDN (already included)
5. **Monitoring**: Add Sentry for error tracking

## Development Environment

```
Local Machine
    │
    ├─ Backend (Flask)
    │  localhost:5000
    │
    ├─ User Dashboard (React)
    │  localhost:3000
    │
    └─ Admin Dashboard (React)
       localhost:3001
```

## Production Environment

```
Cloud
    │
    ├─ Backend (Flask + Gunicorn)
    │  https://ai-feedback-backend.onrender.com
    │
    ├─ User Dashboard (React)
    │  https://user-dashboard.vercel.app
    │
    └─ Admin Dashboard (React)
       https://admin-dashboard.vercel.app
```

## Error Handling

### Common Errors and Solutions

| Error | Cause | Solution |
|-------|-------|----------|
| CORS Error | Backend not running | Start Flask server |
| 500 Error | API Key invalid | Check Gemini API key |
| Network Error | Services down | Check Render/Vercel status |
| Empty Admin Dashboard | No submissions yet | Submit a review first |
| 404 Not Found | Wrong endpoint | Check API endpoint URL |

## Performance Metrics

### Targets
- **User Dashboard Load**: < 2 seconds
- **Admin Dashboard Load**: < 3 seconds
- **Submission Processing**: < 10 seconds (including AI response)
- **Analytics Calculation**: < 1 second

### Monitoring
- Backend: Render logs
- Frontend: Vercel analytics
- API: Response times

## Future Enhancements

1. **Database**: PostgreSQL for reliability
2. **Authentication**: Admin login for dashboard
3. **Export**: CSV/PDF export of submissions
4. **Notifications**: Email alerts for critical reviews
5. **Sentiment Analysis**: Additional AI insights
6. **Custom Themes**: Admin-controlled styling
7. **Mobile App**: React Native version
8. **WebSocket**: Real-time updates without polling
