# TypeScript / viem Policy Helper

This repo now ships a TypeScript helper wrapper for local policy workflows.

## What it provides

- list available cookbook policy templates
- load a named template from `examples/policies/`
- create a policy on Forte Rules Engine
- optionally apply that policy to the demo token

## Files

- `scripts/policy-helper.ts` — reusable helper module
- `scripts/apply-policy-template.ts` — CLI entrypoint

## Quick usage

### 1) List templates

```bash
npm run policy:templates
```

### 2) Apply a template using `.env`

```bash
npm run policy:apply-template -- --template strict-no-exemptions
```

### 3) Create-only mode (no apply)

```bash
npm run policy:apply-template -- --template treasury-emergency-freeze --create-only
```

### 4) Explicit arguments (no `.env` fallback)

```bash
npm run policy:apply-template -- \
  --template retail-cap-with-treasury-bypass \
  --rpc http://127.0.0.1:8545 \
  --private-key 0x... \
  --rules-engine 0x... \
  --token 0x...
```

### 5) Save machine-readable output

```bash
npm run policy:apply-template -- --template lockup-and-sanctions-only --out cache/policy-helper-result.json
```

## Env fallback

The CLI auto-loads `./.env` if present and reads:

- `RPC_URL`
- `PRIV_KEY`
- `RULES_ENGINE_ADDRESS`
- `TOKEN_ADDRESS`

## Notes

- Current helper is intentionally local-first and targets the anvil/foundry path used by this repo.
- For production networks, keep the same workflow pattern but update chain/client configuration and key management to match your deployment standards.
