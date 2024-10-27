#!/usr/bin/env python3

# Script that fetches RSS feed from a news site (e.g. BBC News).

import feedparser


def fetch_rss_feed(url):
    # Parse the RSS feed.
    feed = feedparser.parse(url)

    # Check for feed validity.
    if feed.bozo:
        print("Invalid RSS feed.")
        return

    result = {
           'feed': feed.feed.title,
        'entries': []
    }

    # Display each entry in the feed.
    for entry in feed.entries:
        result['entries'].append({
            'link': entry.link,
            'date': entry.published,
            'title':entry.title,
            'summary': entry.summary
        })

    return result


def print_entry(entry):
    # Display feed title
    print(f"   Link: {entry['link']}")
    print(f"   Date: {entry['date']}")
    print(f"  Title: {entry['title']}")
    print(f"Summary: {entry['summary']}\n")


def example_bbc():
    # Fetch news feed from BBC News and display news summaries.
    rss_url_bbc = "https://feeds.bbci.co.uk/news/rss.xml"
    news = fetch_rss_feed(rss_url_bbc)
    print(f"Results for: {news['feed']}\n\n")
    for news in news['entries']:
        print_entry(news)


if __name__ == "__main__":
    example_bbc()
