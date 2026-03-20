# Local Policy Playground

This playground is a local UI for comparing cookbook policy postures and simulating transfer outcomes.

## What it does

- select one of the policy templates in `examples/policies/`
- choose calling function (`transfer` / `transferFrom`)
- set transfer context inputs (value, maxTransfer, lock timestamps, blacklist flags, treasury flag)
- see rule-by-rule pass/fail and final allow/revert outcome

## Start

```bash
npm run playground:start
```

Then open:

- `http://127.0.0.1:4173/playground/`

Use a custom port:

```bash
npm run playground:start -- 8080
```

## Notes

- this is a local simulation tool, not an on-chain execution engine
- it evaluates rule conditions from policy JSON in-browser for fast posture comparison
- use it to sanity-check design intent before creating/applying policies on local anvil
