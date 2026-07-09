// Copyright (c) 2026, Ayesh Almeida.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
// either express or implied. See the License for the specific
// language governing permissions and limitations under the License.

import ballerina/os;
import ballerina/test;

// Smoke tests against the real Tavily API. They spend real credits, so they are excluded by
// default (see the root build.gradle, which sets `disable = 'live'` unless `-Pgroups=live` is
// passed). Run them explicitly with:
//   ./gradlew test -Pgroups=live
// or, directly with the Ballerina tool, from the `ballerina` directory:
//   bal test --groups live
// Both require a real Tavily API key exported as the TAVILY_API_KEY environment variable.

final string liveApiKey = os:getEnv("TAVILY_API_KEY");

@test:Config {groups: ["live"]}
function testLiveSearch() returns error? {
    Client liveClient = check new (config = {auth: {token: liveApiKey}});
    SearchResponse response = check liveClient->/search.post(payload = {
        query: "What is the Ballerina programming language?",
        search_depth: "basic",
        max_results: 1
    });

    SearchResult[]? results = response.results;
    test:assertTrue(results is SearchResult[]);
    if results is SearchResult[] {
        test:assertTrue(results.length() > 0);
    }
}

@test:Config {groups: ["live"]}
function testLiveUsage() returns error? {
    Client liveClient = check new (config = {auth: {token: liveApiKey}});
    UsageResponse response = check liveClient->/usage.get();

    KeyUsage? keyUsage = response.'key;
    test:assertTrue(keyUsage is KeyUsage);
}
