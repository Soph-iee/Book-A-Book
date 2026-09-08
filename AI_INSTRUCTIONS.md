# AI Instructions

These instructions apply to all AI-assisted work in this repository. Follow them for every response, code edit, and generated artifact.

## 1. Expand every abbreviation and acronym

On first use in any chat response or code comment, write the full meaning followed by the abbreviation in parentheses.

- Example: write `PKCE (Proof Key for Code Exchange)`, not just `PKCE`.
- Example: write `REST (Representational State Transfer)`, `JWT (JSON Web Token)`, `RLS (Row Level Security)`, `OTP (One-Time Password)`, `URI (Uniform Resource Identifier)`, `SDK (Software Development Kit)`.
- If the same abbreviation recurs later in the same response, the expanded form is no longer required after the first definition.

## 2. Write industry-standard, clean, and efficient code

- Follow the existing project conventions (Riverpod for state, go_router for routing, supabase_flutter for backend). Do not introduce new patterns or libraries without justification.
- Prefer the simplest correct solution. Avoid premature abstraction and unnecessary boilerplate.
- Write efficient code: minimize network round trips, avoid redundant writes, prefer idempotent operations, and do not allocate or compute more than the task requires.
- Keep functions small and single-purpose. Name things clearly and unambiguously.
- Do not add comments unless explicitly requested. When comments are present in the surrounding code, match their style.
- Never commit secrets or keys. Handle errors through the project's existing failure types rather than raw exceptions.

## Scope

These two rules are the baseline. Project-specific guidance (for example, the Codex-oriented `AGENTS.md`) remains in effect where it does not conflict with the rules above.
