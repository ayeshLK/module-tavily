# Ballerina Tavily connector

[![Build](https://github.com/ayeshLK/module-tavily/actions/workflows/ci.yml/badge.svg)](https://github.com/ayeshLK/module-tavily/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ayeshLK/module-tavily.svg)](https://github.com/ayeshLK/module-tavily/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ayeshLK/module-tavily.svg?label=Open%20Issues)](https://github.com/ayeshLK/module-tavily/issues)

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

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Export a GitHub personal access token with read package permissions as follows:

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

   This connector also has a `live` test group that calls the real Tavily API (used by the release
   workflow). It requires a live API key and is excluded by default; run it explicitly with:

   ```bash
   ./gradlew clean test -Pgroups=live
   ```

3. To build the package without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

5. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`tavily` package](https://central.ballerina.io/ayesha/tavily/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
