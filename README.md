# News Sentiment Oracle


## Overview
**News Sentiment Oracle** is a blockchain-based oracle that tracks public sentiment from news articles using AI-powered sentiment analysis. This oracle categorizes news as positive, neutral, or negative and securely stores this data on-chain, making it accessible for use in decentralized applications (dApps).


## Key Features

- **"AI for Good"**: Designed to support fair and fact-based applications, from ethical reporting algorithms to media bias detection.

- **Daily Sentiment Analysis**: Uses AI algorithms to analyze and classify news articles as negative, neutral, or positive, keeping a record of news zeitgeist per day, enabling sentiment trend analysis.

- **Transparent Data Storage**: Aggregated sentiment data is stored on-chain, allowing dApps to access trustworthy, transparent information.


## Use Cases

- **Media Transparency**: Provides a public record of sentiment data, promoting balanced reporting and empowering users with sentiment trends, and hopefully shifting the focus away from constant negativity into more constructive and positive stories.

- **Risk Management**: Enables DeFi platforms to correlate strategies based on sentiment trends, enhancing risk assessment.


## Project Structure

- **Oracle Smart Contract**: The main contract that stores and provides access to sentiment data.

- **Sentiment Analysis Engine**: An off-chain AI component that scrapes and analyzes news articles, sending data to the oracle.


## How It Works

1. **Data Collection**: News articles are scraped from selected sources using RSS feeds (using: ___./sentiment-rss-data-scrapper___).

2. **Sentiment Classification**: The sentiment analysis engine processes each article, classifying it as positive, neutral, or negative (using: ___./sentiment-aivm___).

3. **On-Chain Storage**: Aggregated sentiment data is sent to the blockchain, where it’s stored in the oracle contract (using: ___Base___ and ___Flare___ blockchains).

4. **dApp Integration**: Decentralized applications can query the oracle for sentiment data, making use of it in various applications (naturally using ___EMV___ integrations).


## Getting Started
1. Clone the repository:  
   ```
   git clone https://github.com/anton-io/encode-london2024-sentiment-oracle
   ```

2. Start the Sentiment AI Virtual Machine:
   ```
   cd ./sentiment-aivm
   ./_0_build    # To build the docker container.
   ./_1_run      # Run the API service
   ./_2_example  # Optionally, verify correct operation. 
   ```
3. Fetch and aggregate news sentiments for previous day:
   ```
   ./sentiment-news-aggregator/news_aggregator.py
   ```
4. Update the blockchain/s with the values produced using the operator utility provided:
   ```
   ./sentiment-oracle-<chain>/operator
   ```

## Deployed Into Testnets

This Sentiment Oracle has been deployed and verified in a number of test chains including:

* Base: [0xa1AC5bD954aa0857F15287eC67Fee4d5587f6E04](https://sepolia.basescan.org/address/0xa1AC5bD954aa0857F15287eC67Fee4d5587f6E04#code)
* Flare: [0x83A2f0c720497e953b5Cc541f1ac11E9867EF494](https://coston2-explorer.flare.network/address/0x83A2f0c720497e953b5Cc541f1ac11E9867EF494?tab=contract)

In the case of the Flare deployment, it makes use of Flare's Time Series Oracle to hydrate sentiment entries with bitcoin prices too. This allows for easy analysis of trends and impact of news sentiment on the price of "digital gold". 
