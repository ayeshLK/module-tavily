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
function testExtractSingleUrl() returns error? {
    ExtractResponse response = check mockClient->/extract.post(payload = {
        urls: "https://ballerina.io"
    });

    ExtractResult[]? results = response.results;
    test:assertTrue(results is ExtractResult[]);
    if results is ExtractResult[] {
        test:assertEquals(results.length(), 1);
        test:assertEquals(results[0].url, "https://ballerina.io");
    }
}

@test:Config {}
function testExtractMultipleUrls() returns error? {
    ExtractResponse response = check mockClient->/extract.post(payload = {
        urls: ["https://ballerina.io", "https://example.com"]
    });

    ExtractResult[]? results = response.results;
    test:assertTrue(results is ExtractResult[]);
    if results is ExtractResult[] {
        test:assertEquals(results[0].url, "https://ballerina.io");
    }
}
