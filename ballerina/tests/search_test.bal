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

import ballerina/test;

@test:Config {}
function testSearchReturnsAnswerAndResults() returns error? {
    SearchResponse response = check mockClient->/search.post(payload = {
        query: "Who is Leo Messi?",
        include_answer: true
    });

    test:assertEquals(response.query, "Who is Leo Messi?");
    test:assertEquals(response.answer, "Mock answer for the query.");
    SearchResult[]? results = response.results;
    test:assertTrue(results is SearchResult[]);
    if results is SearchResult[] {
        test:assertEquals(results.length(), 1);
        test:assertEquals(results[0].title, "Mock Result");
    }
}

@test:Config {}
function testSearchForwardsSessionIdHeader() returns error? {
    SearchResponse response = check mockClient->/search.post(
        payload = {query: "test query"},
        headers = {X\-Session\-Id: "abc-session"}
    );

    test:assertEquals(response.request_id, "abc-session");
}

@test:Config {}
function testSearchFailsWithInvalidApiKey() returns error? {
    SearchResponse|error response = unauthorizedClient->/search.post(payload = {query: "test query"});
    test:assertTrue(response is error);
}
