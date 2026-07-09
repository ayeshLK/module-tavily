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
function testCreateResearchTaskReturnsPending() returns error? {
    ResearchTaskCreated response = check mockClient->/research.post(payload = {
        input: "What are the latest developments in AI?"
    });

    test:assertEquals(response.status, "pending");
    test:assertEquals(response.input, "What are the latest developments in AI?");
}

@test:Config {}
function testGetResearchTaskCompleted() returns error? {
    ResearchTaskCompleted|ResearchTaskFailed|ResearchTaskPending response =
        check mockClient->/research/[COMPLETED_TASK_ID].get();

    test:assertTrue(response is ResearchTaskCompleted);
    if response is ResearchTaskCompleted {
        test:assertEquals(response.status, "completed");
        ResearchSource[]? sources = response.sources;
        test:assertTrue(sources is ResearchSource[]);
    }
}

@test:Config {}
function testGetResearchTaskFailed() returns error? {
    ResearchTaskCompleted|ResearchTaskFailed|ResearchTaskPending response =
        check mockClient->/research/[FAILED_TASK_ID].get();

    test:assertTrue(response is ResearchTaskFailed);
}

@test:Config {}
function testGetResearchTaskPending() returns error? {
    ResearchTaskCompleted|ResearchTaskFailed|ResearchTaskPending response =
        check mockClient->/research/[PENDING_TASK_ID].get();

    test:assertTrue(response is ResearchTaskPending);
}

@test:Config {}
function testGetResearchTaskNotFound() returns error? {
    ResearchTaskCompleted|ResearchTaskFailed|ResearchTaskPending|error response =
        mockClient->/research/["unknown-task-id"].get();

    test:assertTrue(response is error);
}
