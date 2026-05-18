# Using Agent Profiles with Ollama (Local Models)

Ollama runs models locally via a Modelfile. Inject the role profile into the `SYSTEM` block of the Modelfile. The model has no file-reading capability — all context must be baked into the Modelfile or passed in the prompt.

## How to Assign a Role

Create or edit a Modelfile:

```modelfile
FROM llama3.2

SYSTEM """
You are acting as [Role Name].

[PASTE CONTENTS OF agents/role-file.md]

Apply Rule 13 — Circular Hand-off Workflow:
- You receive work from: [previous role]
- You deliver: [hand-off format from profile]
- You pass to: [next role]

Follow all rules in rules/universal.md (pasted below):
[PASTE RELEVANT SECTIONS OF rules/universal.md]
"""

PARAMETER temperature 0.3
PARAMETER num_ctx 8192
```

Build the model:
```bash
ollama create [role-name]-agent -f Modelfile
```

Run it:
```bash
ollama run [role-name]-agent
```

## Multi-Agent Workflows

Each role requires a separate named Ollama model. Chain them by piping output between models:

```bash
# Run PM role, save output as requirements brief
ollama run pm-agent "Create a requirements brief for: [feature description]" > brief.txt

# Run UX role, passing PM's output
ollama run ux-agent "$(cat brief.txt)" > wireframe-notes.txt
```

## Model Recommendations by Role

| Role | Recommended model | Minimum VRAM |
|------|------------------|-------------|
| Product Manager | llama3.2:3b | 4GB |
| UX / UI Designer | llama3.2:3b | 4GB |
| Backend / Frontend Dev | qwen2.5-coder:14b | 10GB |
| Tech Lead / Architect | qwen2.5-coder:32b | 20GB |
| Security Engineer | llama3.1:8b | 6GB |
| QA Engineer | llama3.2:3b | 4GB |

## Capability Notes

| Capability | Ollama |
|-----------|--------|
| Read profile file | ❌ (baked into Modelfile) |
| Write files | ❌ (output to stdout only) |
| Tool calling | ✅ (model-dependent) |
| Internet access | ❌ |
| Circular workflow | Manual (pipe between models) |

## Acknowledgment

Run the Ollama model with both rule files in context and ask it to produce the acknowledgment JSON. The model outputs it to stdout — the user pastes it into `acknowledgments/ollama.ack.json`.

See `rules/ollama.md` for the complete Modelfile SYSTEM block template.
