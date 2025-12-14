import React, { useState } from 'react';
import axios from 'axios';
import './App.css';

function App() {
  const [rating, setRating] = useState(5);
  const [review, setReview] = useState('');
  const [loading, setLoading] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [aiResponse, setAiResponse] = useState(null);
  const [error, setError] = useState('');

  const API_BASE = 'https://fynd-1-g3ui.onrender.com';

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!review.trim()) {
      setError('Please write a review');
      return;
    }

    setLoading(true);
    setError('');

    try {
      const response = await axios.post(`${API_BASE}/api/submit-review`, {
        rating: parseInt(rating),
        review: review.trim()
      });

      setAiResponse(response.data.submission);
      setSubmitted(true);
      setReview('');
      setRating(5);
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to submit review. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="container">
      <header className="header">
        <h1>✨ Share Your Feedback</h1>
        <p>Help us improve by sharing your thoughts</p>
      </header>

      {!submitted ? (
        <form onSubmit={handleSubmit} className="form">
          <div className="form-group">
            <label>Rate Your Experience</label>
            <div className="star-rating">
              {[1, 2, 3, 4, 5].map((star) => (
                <button
                  key={star}
                  type="button"
                  className={`star ${rating >= star ? 'active' : ''}`}
                  onClick={() => setRating(star)}
                >
                  ⭐
                </button>
              ))}
            </div>
            <p className="rating-display">{rating} out of 5 stars</p>
          </div>

          <div className="form-group">
            <label htmlFor="review">Your Review</label>
            <textarea
              id="review"
              value={review}
              onChange={(e) => setReview(e.target.value)}
              placeholder="Tell us what you think..."
              rows={6}
              disabled={loading}
            />
          </div>

          {error && <div className="error-message">{error}</div>}

          <button type="submit" disabled={loading} className="submit-btn">
            {loading ? 'Submitting...' : 'Submit Review'}
          </button>
        </form>
      ) : (
        <div className="success-container">
          <div className="success-message">
            <h2>✅ Thank You!</h2>
            <p>Your review has been submitted successfully.</p>
          </div>

          {aiResponse && (
            <div className="ai-response">
              <h3>AI-Generated Response</h3>
              <p className="response-text">{aiResponse.response}</p>
              
              <h4>Summary</h4>
              <p className="summary-text">{aiResponse.summary}</p>
              
              {aiResponse.actions && aiResponse.actions.length > 0 && (
                <>
                  <h4>Recommended Actions</h4>
                  <ul className="actions-list">
                    {aiResponse.actions.map((action, idx) => (
                      <li key={idx}>{action}</li>
                    ))}
                  </ul>
                </>
              )}
            </div>
          )}

          <button
            onClick={() => setSubmitted(false)}
            className="submit-another-btn"
          >
            Submit Another Review
          </button>
        </div>
      )}
    </div>
  );
}

export default App;
