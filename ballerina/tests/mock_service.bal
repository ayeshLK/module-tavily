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

import ballerina/http;

const string MOCK_SERVICE_URL = "http://localhost:9100";
const string TEST_API_KEY = "tvly-test-key";

const string COMPLETED_TASK_ID = "task-completed";
const string FAILED_TASK_ID = "task-failed";
const string PENDING_TASK_ID = "task-pending";

type ErrorDetail record {|
    string 'error;
|};

type ErrorBody record {|
    ErrorDetail detail;
|};

listener http:Listener mockListener = new (9100);

final Client mockClient = check new (config = {auth: {token: TEST_API_KEY}}, serviceUrl = MOCK_SERVICE_URL);
final Client unauthorizedClient = check new (config = {auth: {token: "wrong-key"}}, serviceUrl = MOCK_SERVICE_URL);

isolated function checkAuthorization(http:Request req) returns http:Unauthorized? {
    string|http:HeaderNotFoundError authHeader = req.getHeader("Authorization");
    if authHeader is string && authHeader == string `Bearer ${TEST_API_KEY}` {
        return ();
    }
    ErrorBody unauthorizedBody = {detail: {'error: "Unauthorized: missing or invalid API key."}};
    http:Unauthorized unauthorizedResponse = {body: unauthorizedBody};
    return unauthorizedResponse;
}

isolated function extractSessionId(http:Request req) returns string? {
    string|http:HeaderNotFoundError sessionId = req.getHeader("X-Session-Id");
    if sessionId is string {
        return sessionId;
    }
    return ();
}

isolated function resolveFirstUrl(string|string[] urls) returns string {
    if urls is string {
        return urls;
    }
    return urls.length() > 0 ? urls[0] : "";
}

service / on mockListener {

    resource function post search(@http:Payload SearchRequest payload, http:Request req)
            returns SearchResponse|http:Unauthorized {
        http:Unauthorized? unauthorized = checkAuthorization(req);
        if unauthorized is http:Unauthorized {
            return unauthorized;
        }
        string? sessionId = extractSessionId(req);
        SearchResult mockResult = {
            title: "Mock Result",
            url: "https://example.com/mock",
            content: "Mock content snippet.",
            score: 0.9
        };
        SearchResponse response = {
            query: payload.query,
            answer: "Mock answer for the query.",
            images: [],
            results: [mockResult],
            response_time: 0.42,
            request_id: sessionId ?: "mock-search-request-id"
        };
        return response;
    }

    resource function post extract(@http:Payload ExtractRequest payload, http:Request req)
            returns ExtractResponse|http:Unauthorized {
        http:Unauthorized? unauthorized = checkAuthorization(req);
        if unauthorized is http:Unauthorized {
            return unauthorized;
        }
        string sourceUrl = resolveFirstUrl(payload.urls);
        ExtractResult mockResult = {url: sourceUrl, raw_content: "Mock extracted content."};
        ExtractResponse response = {
            results: [mockResult],
            failed_results: [],
            response_time: 0.31,
            request_id: "mock-extract-request-id"
        };
        return response;
    }

    resource function post crawl(@http:Payload CrawlRequest payload, http:Request req)
            returns CrawlResponse|http:Unauthorized {
        http:Unauthorized? unauthorized = checkAuthorization(req);
        if unauthorized is http:Unauthorized {
            return unauthorized;
        }
        string baseUrl = payload.url;
        CrawlResult mockResult = {url: baseUrl + "/page1", raw_content: "Mock crawled content."};
        CrawlResponse response = {
            base_url: baseUrl,
            results: [mockResult],
            response_time: 1.1,
            request_id: "mock-crawl-request-id"
        };
        return response;
    }

    resource function post 'map(@http:Payload MapRequest payload, http:Request req)
            returns MapResponse|http:Unauthorized {
        http:Unauthorized? unauthorized = checkAuthorization(req);
        if unauthorized is http:Unauthorized {
            return unauthorized;
        }
        string baseUrl = payload.url;
        MapResponse response = {
            base_url: baseUrl,
            results: [baseUrl + "/page1", baseUrl + "/page2"],
            response_time: 0.8,
            request_id: "mock-map-request-id"
        };
        return response;
    }

    resource function post research(@http:Payload ResearchRequest payload, http:Request req)
            returns http:Created|http:Unauthorized {
        http:Unauthorized? unauthorized = checkAuthorization(req);
        if unauthorized is http:Unauthorized {
            return unauthorized;
        }
        ResearchTaskCreated created = {
            request_id: PENDING_TASK_ID,
            created_at: "2025-01-15T10:30:00Z",
            status: "pending",
            input: payload.input,
            model: "mini",
            response_time: 1.0
        };
        http:Created createdResponse = {body: created};
        return createdResponse;
    }

    resource function get research/[string taskId](http:Request req)
            returns ResearchTaskCompleted|ResearchTaskFailed|ResearchTaskPending|http:NotFound|http:Unauthorized {
        http:Unauthorized? unauthorized = checkAuthorization(req);
        if unauthorized is http:Unauthorized {
            return unauthorized;
        }
        if taskId == COMPLETED_TASK_ID {
            ResearchTaskCompleted completed = {
                request_id: COMPLETED_TASK_ID,
                created_at: "2025-01-15T10:30:00Z",
                status: "completed",
                content: "Mock research report about recent AI developments.",
                sources: [
                    {title: "Mock Source", url: "https://example.com/source", favicon: "https://example.com/favicon.ico"}
                ],
                response_time: 12
            };
            return completed;
        }
        if taskId == FAILED_TASK_ID {
            ResearchTaskFailed failed = {request_id: FAILED_TASK_ID, status: "failed", response_time: 5};
            return failed;
        }
        if taskId == PENDING_TASK_ID {
            ResearchTaskPending pending = {request_id: PENDING_TASK_ID, status: "pending", response_time: 2};
            return pending;
        }
        ErrorBody notFoundBody = {detail: {'error: "Research task does not exist."}};
        http:NotFound notFoundResponse = {body: notFoundBody};
        return notFoundResponse;
    }

    resource function get usage(http:Request req) returns UsageResponse|http:Unauthorized {
        http:Unauthorized? unauthorized = checkAuthorization(req);
        if unauthorized is http:Unauthorized {
            return unauthorized;
        }
        KeyUsage keyUsage = {
            usage: 120,
            'limit: 1000,
            search_usage: 100,
            extract_usage: 10,
            crawl_usage: 5,
            map_usage: 3,
            research_usage: 2
        };
        AccountUsage accountUsage = {
            current_plan: "Developer",
            plan_usage: 120,
            plan_limit: 1000,
            paygo_usage: 0,
            paygo_limit: 0,
            search_usage: 100,
            extract_usage: 10,
            crawl_usage: 5,
            map_usage: 3,
            research_usage: 2
        };
        UsageResponse response = {'key: keyUsage, account: accountUsage};
        return response;
    }
}
