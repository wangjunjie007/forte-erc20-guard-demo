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

Less useful contributions:
- unrelated token features
- speculative protocol complexity that weakens the teaching value
- unnecessary framework churn

## Style

- keep the ERC20 path readable
- prefer explicitness over abstraction tricks
- preserve deterministic local validation
- document any new moving part
