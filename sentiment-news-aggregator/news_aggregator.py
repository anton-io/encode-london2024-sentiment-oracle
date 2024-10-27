#!/usr/bin/env python3

#  This script aggregates news into daily summaries, so they can be input
# into the Sentiment Oracles.

from datetime import datetime


import sys
sys.path.append('../sentiment-rss-data-scrapper')
sys.path.append('../sentiment-aivm/aivm-senti-cli')

from rss_news_fetch import fetch_rss_feed
from aivm_sentiment import get_sentiment

# Date format used by RSS feed.
date_format = "%a, %d %b %Y %H:%M:%S %Z"


def news_aggregator(url="https://feeds.bbci.co.uk/news/rss.xml"):
    # Fetch news feed from URL and aggregate their sentiment into [negative, neutral, positive].
    news = fetch_rss_feed(url)
    print(f"Results for: {news['feed']}\n")
    aggregated_results = {}
    for news in news['entries']:
        date_obj = datetime.strptime(news['date'], date_format)
        key = date_obj.strftime("%Y/%m/%d")
        if key not in aggregated_results:
            aggregated_results[key] = [0, 0, 0]
        sentiment = get_sentiment(f"{news['title']}. {news['summary']}")
        if sentiment == '-':
            aggregated_results[key][0] += 1
        elif sentiment == '=':
            aggregated_results[key][1] += 1
        elif sentiment == '+':
            aggregated_results[key][2] += 1
        print(f"{key} [{sentiment}] {news['title'][:50]}")

    for k,v in aggregated_results.items():
        print(k, v)

    return aggregated_results


if __name__ == "__main__":
    # Using BBC as the default.
    news_aggregator()