# Context: RP-Music-Radio

**Last updated**: 2026-05-30
**Repo**: https://github.com/Crashcart/RP-Music-Radio

## What This Is

A music generation and AI DJ system. Generates or streams music and applies AI-driven DJ processing (transitions, mixing, metadata tagging). Part of the broader Universal Software Pipeline initiative (see `plans/` for related pipeline work). Users: the repo owner; potentially public streaming.

## Stack

- TypeScript — frontend / streaming layer
- Python — audio processing and AI DJ pipeline
- Likely integrates with music generation APIs or local models
- Pipeline architecture connects generator → AI DJ → streaming output

## Constraints

- A prior AI session in this repo may have made unauthorized rule changes — verify `git log` before assigning new work
- Audio streaming requires low-latency architecture; standard request/response patterns won't work
- AUDIO STREAMING ENGINEER (Kai Nakamura, hired) is the specialist for this repo
- GitHub language listed as null — primary language detection may be split across Python and TypeScript
- 7 open issues as of onboard (active development — leeway applies)

## Open Issues at Onboard

7 open issues as of 2026-05-30. Pushed 2026-05-29.
