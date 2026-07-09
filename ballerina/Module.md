## Overview

[Tavily](https://tavily.com) is a search engine built for AI agents and LLMs. Its [REST API](https://docs.tavily.com) provides web search, content extraction, site crawling, site mapping, and agentic deep research, all tuned to return results that are easy for an LLM to consume.

The Ballerina Tavily connector lets you call all of these operations from a Ballerina application: search the web, extract clean content from a set of URLs, crawl or map a site graph, kick off and poll a deep research task, and track API key/account credit usage.

> This is an unofficial connector for the Tavily API. It is not reviewed, approved, or endorsed by Tavily.

### Key features

- Search the web with adjustable depth, topic, freshness, and domain filters, and optionally get back an LLM-generated answer
- Extract cleaned, LLM-ready content from a single URL or a batch of up to 20 URLs
- Crawl a site graph following configurable depth/breadth rules, extracting content as it goes
- Map a website to discover its URL structure without extracting page content
- Kick off a deep, agentic research task and poll it until it completes, with cited sources
- Track credit usage per API key and for the account as a whole

## Setup guide

The Tavily API requires an API key for every request.

1. Sign up for a free account at the [Tavily platform](https://app.tavily.com).
2. Generate an API key from the dashboard. It will look like `tvly-YOUR_API_KEY`.

## Quickstart

To use the `tavily` connector in your Ballerina application, follow these steps:

### Step 1: Import the connector

Import the `ayesha/tavily` package into your Ballerina project.

```ballerina
import ayesha/tavily;
```

### Step 2: Instantiate a new connector

Create a `tavily:Client` using your API key as a bearer token.

```ballerina
tavily:Client tavilyClient = check new ({
    auth: {
        token: "<Your Tavily API Key>"
    }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Search the web

```ballerina
tavily:SearchResponse response = check tavilyClient->/search.post({
    query: "Who is Leo Messi?",
    include_answer: true
});

io:println(response.answer);
```

#### Extract content from a URL

```ballerina
tavily:ExtractResponse response = check tavilyClient->/extract.post({
    urls: ["https://ballerina.io"]
});

io:println(response.results[0].raw_content);
```
