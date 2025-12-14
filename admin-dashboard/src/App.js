import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

function App() {
  const [submissions, setSubmissions] = useState([]);
  const [analytics, setAnalytics] = useState(null);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState('all');
  const [error, setError] = useState('');
  const [autoRefresh, setAutoRefresh] = useState(true);

  const API_BASE = 'https://fynd-1-g3ui.onrender.com';

  useEffect(() => {
    fetchData();
    
    if (autoRefresh) {
      const interval = setInterval(fetchData, 5000); // Refresh every 5 seconds
      return () => clearInterval(interval);
    }
  }, [autoRefresh]);

  const fetchData = async () => {
    try {
      const [submissionsRes, analyticsRes] = await Promise.all([
        axios.get(`${API_BASE}/api/submissions`),
        axios.get(`${API_BASE}/api/analytics`)
      ]);

      setSubmissions(submissionsRes.data);
      setAnalytics(analyticsRes.data);
      setError('');
    } catch (err) {
      setError('Failed to fetch data. Backend may not be running.');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const getStarDisplay = (rating) => {
    return '⭐'.repeat(rating) + '☆'.repeat(5 - rating);
  };

  const filteredSubmissions = submissions.filter(sub => {
    if (filter === 'all') return true;
    return sub.rating === parseInt(filter);
  });

  const sortedSubmissions = [...filteredSubmissions].reverse(); // Show newest first

  if (loading) {
    return (
      <div className="container">
        <div className="loading">Loading...</div>
      </div>
    );
  }

  return (
    <div className="container">
      <header className="admin-header">
        <h1>📊 Admin Dashboard</h1>
        <p>Real-time feedback monitoring & analytics</p>
      </header>

      <div className="controls">
        <button 
          className={`refresh-btn ${autoRefresh ? 'active' : ''}`}
          onClick={() => setAutoRefresh(!autoRefresh)}
        >
          {autoRefresh ? '🔄 Auto-refresh ON' : '🔄 Auto-refresh OFF'}
        </button>
        <button 
          className="refresh-btn"
          onClick={fetchData}
        >
          🔃 Refresh Now
        </button>
      </div>

      {error && <div className="error-message">{error}</div>}

      {analytics && (
        <div className="analytics-section">
          <h2>Analytics Overview</h2>
          <div className="analytics-grid">
            <div className="analytics-card">
              <div className="analytics-value">{analytics.total_reviews}</div>
              <div className="analytics-label">Total Reviews</div>
            </div>
            <div className="analytics-card">
              <div className="analytics-value">{analytics.average_rating.toFixed(1)}</div>
              <div className="analytics-label">Average Rating</div>
            </div>
            <div className="analytics-card rating-distribution">
              <div className="analytics-label">Rating Distribution</div>
              <div className="distribution-bars">
                {[5, 4, 3, 2, 1].map(star => (
                  <div key={star} className="bar-item">
                    <div className="bar-label">{star}⭐</div>
                    <div className="bar">
                      <div 
                        className="bar-fill"
                        style={{
                          width: analytics.total_reviews > 0 
                            ? ((analytics.rating_distribution[star.toString()] || 0) / analytics.total_reviews) * 100 + '%'
                            : '0%'
                        }}
                      ></div>
                    </div>
                    <div className="bar-count">{analytics.rating_distribution[star.toString()] || 0}</div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      )}

      <div className="submissions-section">
        <h2>Submissions</h2>
        
        <div className="filter-controls">
          <label>Filter by Rating:</label>
          <select value={filter} onChange={(e) => setFilter(e.target.value)}>
            <option value="all">All Ratings</option>
            <option value="5">5 Stars</option>
            <option value="4">4 Stars</option>
            <option value="3">3 Stars</option>
            <option value="2">2 Stars</option>
            <option value="1">1 Star</option>
          </select>
        </div>

        {sortedSubmissions.length === 0 ? (
          <div className="no-submissions">
            <p>No submissions yet</p>
          </div>
        ) : (
          <div className="submissions-list">
            <p className="submission-count">
              Showing {sortedSubmissions.length} submission{sortedSubmissions.length !== 1 ? 's' : ''}
            </p>
            {sortedSubmissions.map((submission) => (
              <div key={submission.id} className="submission-card">
                <div className="submission-header">
                  <div className="rating-badge">{getStarDisplay(submission.rating)}</div>
                  <div className="submission-time">
                    {new Date(submission.timestamp).toLocaleString()}
                  </div>
                </div>

                <div className="submission-content">
                  <h4>User Review</h4>
                  <p className="review-text">{submission.review}</p>

                  {submission.summary && (
                    <>
                      <h4>AI Summary</h4>
                      <p className="summary-text">{submission.summary}</p>
                    </>
                  )}

                  {submission.response && (
                    <>
                      <h4>AI Response</h4>
                      <p className="response-text">{submission.response}</p>
                    </>
                  )}

                  {submission.actions && submission.actions.length > 0 && (
                    <>
                      <h4>Recommended Actions</h4>
                      <ul className="actions-list">
                        {submission.actions.map((action, idx) => (
                          <li key={idx}>
                            <span className="action-icon">→</span>
                            {action}
                          </li>
                        ))}
                      </ul>
                    </>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

export default App;
