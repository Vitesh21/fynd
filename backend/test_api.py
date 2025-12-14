import sys
import json
import requests
from datetime import datetime

# Test the backend API
BASE_URL = "http://localhost:5000"

def test_health():
    """Test health endpoint"""
    try:
        response = requests.get(f"{BASE_URL}/api/health", timeout=5)
        print(f"✓ Health Check: {response.json()}")
        return response.status_code == 200
    except Exception as e:
        print(f"✗ Health Check failed: {e}")
        return False

def test_submit_review():
    """Test submitting a review"""
    try:
        payload = {
            "rating": 5,
            "review": "This is a test review! The AI Feedback System is amazing!"
        }
        response = requests.post(
            f"{BASE_URL}/api/submit-review",
            json=payload,
            timeout=10
        )
        
        if response.status_code == 201:
            data = response.json()
            print(f"✓ Review Submitted")
            print(f"  - AI Response: {data['submission']['response'][:100]}...")
            print(f"  - Summary: {data['submission']['summary']}")
            print(f"  - Actions: {data['submission']['actions']}")
            return True
        else:
            print(f"✗ Failed to submit review: {response.json()}")
            return False
    except Exception as e:
        print(f"✗ Submit Review failed: {e}")
        return False

def test_get_submissions():
    """Test getting all submissions"""
    try:
        response = requests.get(f"{BASE_URL}/api/submissions", timeout=5)
        if response.status_code == 200:
            submissions = response.json()
            print(f"✓ Got submissions: {len(submissions)} total")
            return True
        else:
            print(f"✗ Failed to get submissions: {response.json()}")
            return False
    except Exception as e:
        print(f"✗ Get Submissions failed: {e}")
        return False

def test_get_analytics():
    """Test getting analytics"""
    try:
        response = requests.get(f"{BASE_URL}/api/analytics", timeout=5)
        if response.status_code == 200:
            analytics = response.json()
            print(f"✓ Analytics Retrieved")
            print(f"  - Total Reviews: {analytics['total_reviews']}")
            print(f"  - Average Rating: {analytics['average_rating']}")
            print(f"  - Distribution: {analytics['rating_distribution']}")
            return True
        else:
            print(f"✗ Failed to get analytics: {response.json()}")
            return False
    except Exception as e:
        print(f"✗ Get Analytics failed: {e}")
        return False

def main():
    print("=" * 50)
    print("AI Feedback System - API Tests")
    print("=" * 50)
    print()
    
    tests = [
        ("Health Check", test_health),
        ("Submit Review", test_submit_review),
        ("Get Submissions", test_get_submissions),
        ("Get Analytics", test_get_analytics),
    ]
    
    results = []
    for name, test_func in tests:
        print(f"\nRunning: {name}")
        result = test_func()
        results.append((name, result))
    
    print("\n" + "=" * 50)
    print("Test Summary")
    print("=" * 50)
    
    for name, result in results:
        status = "PASS" if result else "FAIL"
        symbol = "✓" if result else "✗"
        print(f"{symbol} {name}: {status}")
    
    passed = sum(1 for _, r in results if r)
    total = len(results)
    print(f"\nTotal: {passed}/{total} tests passed")
    
    if passed == total:
        print("\n✓ All tests passed! The API is working correctly.")
        return 0
    else:
        print("\n✗ Some tests failed. Check the backend logs.")
        return 1

if __name__ == "__main__":
    sys.exit(main())
