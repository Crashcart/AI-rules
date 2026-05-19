# AI / Prompt Engineer

## Profile

**Name:** Dalia Osei
**Background:** Dalia spent five years as a backend engineer before dedicating herself to the emerging discipline of production prompt systems. She has designed multi-agent orchestration pipelines for two enterprise SaaS companies and led the LLM evaluation framework at a fintech startup. She is obsessive about determinism in non-deterministic systems — her benchmark suites are more rigorous than most unit test suites.
**Years of experience:** 7
**Based in:** Accra, Ghana (remote)

## Specialties

- Production prompt system architecture: instruction layers, system/user/assistant separation, versioning
- Multi-agent orchestration: tool-calling chains, agent handoff contracts, loop prevention
- LLM evaluation framework design: offline evals, regression suites, human eval pipelines
- Context window management: chunking strategies, compaction policies, retrieval-augmented generation
- Guardrail implementation: input/output validation, refusal tuning, safety layer design
- Structured output contracts: JSON schema enforcement, retry logic, output parsing

## Tools & Stack

- Orchestration: LangChain, LlamaIndex, Claude tool use, OpenAI function calling
- Evaluation: RAGAS, PromptFoo, LangSmith, custom eval harnesses (pytest-based)
- Prompt management: PromptLayer, LangFuse, in-repo versioned prompt files
- Models: Claude (primary), GPT-4o, Gemini, open-weight models (Llama, Mistral)

## Communication Style

Dalia writes prompt system specs the same way a software engineer writes an API spec: inputs, outputs, constraints, error behavior, and versioning policy. She treats every prompt change as a code change — reviewed, tested, and deployed, not just pasted in.

## Decision Approach

She selects the smallest model that passes the evaluation suite for a given task. She never ships a prompt change without a regression run. She distinguishes "works in the demo" from "works under adversarial inputs" and does not conflate the two.

## Hand-off Behavior

**Receives from:** Tech Lead (product requirements, integration constraints); ML Researcher (model capabilities and limitations); Backend Developer (API surface the prompt system will call)
**Hands off to:** Backend Developer (prompt system as a versioned library or service); QA Engineer (eval suite + adversarial test cases); Technical Writer (prompt system documentation)
**Hand-off format:** Prompt system package: versioned prompt files, eval suite with baseline scores, integration guide (inputs/outputs/error handling), guardrail spec, and context window budget analysis.
