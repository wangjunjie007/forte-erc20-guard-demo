# Contributing

Thanks for your interest in improving this demo.

## Local setup

```bash
npm install
forge install foundry-rs/forge-std --no-git
```

## Validation before opening a PR

Run the full local checks:

```bash
npm run check:examples
npm test
npm run check:integration
npm run check:policy
```

## Scope guidance

This repository is intentionally focused.

Good contributions:
- clearer policy-driven token examples
- improved test coverage
- better local reproducibility
- stronger docs and demo material
- additional policy examples that keep the repo readable
- cookbook-style policy templates in `examples/policies/`
- validation improvements for `npm run check:examples`

Less useful contributions:
- unrelated token features
- speculative protocol complexity that weakens the teaching value
- unnecessary framework churn

## Adding a new policy template

1. Add the JSON file to `examples/policies/`
2. Keep it compatible with the encoded values actually forwarded by the current token integration
3. Document the posture in `docs/POLICY_COOKBOOK.md` or `examples/policies/README.md`
4. Run `npm run check:examples` before opening the PR

## Style

- keep the ERC20 path readable
- prefer explicitness over abstraction tricks
- preserve deterministic local validation
- document any new moving part
