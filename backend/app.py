import os
import json
from datetime import datetime
from flask import Flask, request, jsonify
from flask_cors import CORS
import google.generativeai as genai
from pathlib import Path

app = Flask(__name__)
CORS(app)

# Configure Gemini API
API_KEY = "AIzaSyAYH2lCC6PiM3cA5LAO5DecorahRhZPuYI"
genai.configure(api_key=API_KEY)

# Data file path
DATA_FILE = "submissions.json"

def load_submissions():
    """Load submissions from JSON file"""
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE, 'r') as f:
            return json.load(f)
    return []

def save_submissions(submissions):
    """Save submissions to JSON file"""
    with open(DATA_FILE, 'w') as f:
        json.dump(submissions, f, indent=2)

def generate_ai_response(review, rating):
    """Generate AI response using Gemini API"""
    try:
        model = genai.GenerativeModel('gemini-2.5-flash')
        
        # Determine tone based on rating
        if rating == 5:
            tone = "enthusiastic and grateful"
        elif rating == 4:
            tone = "positive and constructive"
        elif rating == 3:
            tone = "neutral and helpful"
        elif rating == 2:
            tone = "empathetic and solution-focused"
        else:
            tone = "apologetic and committed to improvement"
        
        prompt = f"""You are a helpful customer service representative. A customer left a {rating}/5 star review.
        
Your tone should be {tone}.

Customer Review:
"{review}"

Analyze this review and provide a response in JSON format with three keys:
1. "response" - A personalized response to the customer (2-3 sentences)
2. "summary" - A brief summary of the main feedback point (1 sentence)
3. "actions" - A list of 2-3 specific action items or recommendations based on the feedback

Be specific to the content of the review. Different reviews should get different responses.

Return ONLY valid JSON, no other text."""
        
        response = model.generate_content(prompt)
        
        # Parse the response
        try:
            # Extract JSON from response
            response_text = response.text.strip()
            # Try to find JSON in the response
            start = response_text.find('{')
            end = response_text.rfind('}') + 1
            if start != -1 and end > start:
                json_str = response_text[start:end]
                result = json.loads(json_str)
                # Validate required fields
                if not all(key in result for key in ['response', 'summary', 'actions']):
                    raise ValueError("Missing required fields in AI response")
            else:
                # Fallback if JSON not found
                result = {
                    "response": response_text,
                    "summary": review[:100] + "..." if len(review) > 100 else review,
                    "actions": ["Review received and analyzed"]
                }
        except (json.JSONDecodeError, ValueError) as e:
            print(f"JSON parsing error: {e}, Response text: {response_text}")
            result = {
                "response": response_text[:200] if response_text else "Thank you for your feedback!",
                "summary": review[:100] + "..." if len(review) > 100 else review,
                "actions": ["Review received and analyzed"]
            }
        
        return result
    except Exception as e:
        print(f"Error generating AI response: {e}")
        return {
            "response": "Thank you for your feedback!",
            "summary": review[:100],
            "actions": ["Review received and logged"]
        }

@app.route('/api/submit-review', methods=['POST'])
def submit_review():
    """Submit a new review"""
    try:
        data = request.get_json()
        rating = data.get('rating')
        review = data.get('review')
        
        if not rating or not review:
            return jsonify({"error": "Rating and review are required"}), 400
        
        if not (1 <= int(rating) <= 5):
            return jsonify({"error": "Rating must be between 1 and 5"}), 400
        
        # Generate AI response
        ai_data = generate_ai_response(review, rating)
        
        # Create submission
        submission = {
            "id": datetime.now().isoformat(),
            "rating": int(rating),
            "review": review,
            "response": ai_data.get("response", ""),
            "summary": ai_data.get("summary", ""),
            "actions": ai_data.get("actions", []),
            "timestamp": datetime.now().isoformat()
        }
        
        # Save to file
        submissions = load_submissions()
        submissions.append(submission)
        save_submissions(submissions)
        
        return jsonify({
            "success": True,
            "submission": submission
        }), 201
    
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/api/submissions', methods=['GET'])
def get_submissions():
    """Get all submissions"""
    try:
        submissions = load_submissions()
        return jsonify(submissions), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/submissions/<submission_id>', methods=['GET'])
def get_submission(submission_id):
    """Get a specific submission"""
    try:
        submissions = load_submissions()
        for sub in submissions:
            if sub['id'] == submission_id:
                return jsonify(sub), 200
        return jsonify({"error": "Submission not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/analytics', methods=['GET'])
def get_analytics():
    """Get analytics data"""
    try:
        submissions = load_submissions()
        
        if not submissions:
            return jsonify({
                "total_reviews": 0,
                "average_rating": 0,
                "rating_distribution": {"1": 0, "2": 0, "3": 0, "4": 0, "5": 0}
            }), 200
        
        total = len(submissions)
        avg_rating = sum(s['rating'] for s in submissions) / total if submissions else 0
        
        rating_dist = {"1": 0, "2": 0, "3": 0, "4": 0, "5": 0}
        for sub in submissions:
            rating = str(sub['rating'])
            rating_dist[rating] = rating_dist.get(rating, 0) + 1
        
        return jsonify({
            "total_reviews": total,
            "average_rating": round(avg_rating, 2),
            "rating_distribution": rating_dist
        }), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({"status": "healthy"}), 200

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
