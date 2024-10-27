#!/usr/bin/env python3
import requests


def get_sentiment(message):
    url = "http://localhost:8888/sense"
    payload = {"message": message}
    headers = {"Content-Type": "application/json"}

    try:
        # Make a POST request to the Sentiment API endpoint.
        response = requests.post(url, json=payload, headers=headers)

        # Check if the request was successful.
        response.raise_for_status()

        # Parse the JSON response.
        data = response.json()

        # Extract the 'sentiment' value.
        return data.get("sentiment")
    except requests.exceptions.RequestException as e:
        print(f"error: {e}")


def example():
    # Expected output:
    #
    #   Message: Today is a wonderful day to build!
    # Sentiment: Positive

    message   = "Today is a wonderful day to build!"
    sentiment = get_sentiment(message)
    print(f"  Message: {message}")
    if sentiment is not None:
        decoded = {'+': 'Positive', '=': 'Neutral', '-': 'Negative'}.get(sentiment)
        print(f"Sentiment: {decoded}")
    else:
        print("Sentiment value not found in the response.")


if __name__ == "__main__":
    example()

