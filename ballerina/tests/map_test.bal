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
function testMapReturnsDiscoveredUrls() returns error? {
    MapResponse response = check mockClient->/'map.post(payload = {
        url: "https://docs.tavily.com"
    });

    test:assertEquals(response.base_url, "https://docs.tavily.com");
    string[]? results = response.results;
    test:assertTrue(results is string[]);
    if results is string[] {
        test:assertEquals(results.length(), 2);
    }
}
