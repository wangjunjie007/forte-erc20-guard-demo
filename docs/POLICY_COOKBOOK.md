# Policy Cookbook

This repository now includes a small **policy cookbook** so developers can start from named policy postures instead of treating `policy/transfer-guard.policy.json` as a one-off artifact.

## Why this matters

A good Forte integration is not just a contract demo. It is a repeatable way to express policy intent:

- what should retail users be allowed to do?
- what must treasury or ops be able to bypass?
- how do you move into emergency mode without rewriting token logic?
- which constraints belong in policy versus contract storage?

The goal of this cookbook is to make those choices visible and forkable.

---

## Current encoded values in this repo

The demo token currently forwards the following values into Forte Rules Engine:

- `from`
- `to`
- `value`
- `blockTime`
- `fromUnlockTime`
- `fromBlacklistFlag`
- `toBlacklistFlag`
- `treasuryBypass`
- `maxTransfer`

That means the examples in `examples/policies/` are intentionally constrained to postures that can be expressed with those values today.

If you want richer policy behavior later — for example KYC tiers, jurisdiction flags, risk scores, market-hours windows, or allowance bands — extend the token-side encoded values first, then add a new policy template and tests.

---

## Included templates

| Template | Best for | Key idea |
| --- | --- | --- |
| `retail-cap-with-treasury-bypass.policy.json` | Retail token flows | Baseline posture: cap + blacklist + lockup, treasury bypasses cap/lockup |
| `strict-no-exemptions.policy.json` | High-control environments | Same rules for every sender, including treasury |
| `lockup-and-sanctions-only.policy.json` | Vesting / restricted allocations | Remove size cap, keep lockup + blacklist controls |
| `treasury-emergency-freeze.policy.json` | Incident response | Freeze all non-treasury outgoing flow |

---

## Recommended workflow

### 1) Pick a posture

Start by choosing the policy intent closest to your product surface:

- **retail token** → start with `retail-cap-with-treasury-bypass`
- **issuer-managed / tightly controlled asset** → start with `strict-no-exemptions`
- **vesting / employee / partner allocation flows** → start with `lockup-and-sanctions-only`
- **incident response / emergency halt** → start with `treasury-emergency-freeze`

### 2) Copy the template into the active policy file

```bash
cp examples/policies/retail-cap-with-treasury-bypass.policy.json policy/transfer-guard.policy.json
```

### 3) Re-generate the integration layer

```bash
npm run generate:integration
```

### 4) Re-run validation

```bash
npm run check:examples
npm test
npm run check:integration
npm run check:policy
```

---

## Design notes by posture

### Retail cap with treasury bypass

Use this when your token should behave normally for users, but treasury or operations wallets need to move inventory without tripping retail-oriented caps or unlock rules.

Good for:
- treasury inventory rebalancing
- issuer-managed distributions
- staged launch environments where retail controls should not block ops

### Strict no exemptions

Use this when you want Forte to express the posture that **nobody gets a silent bypass**, including treasury-managed paths.

Good for:
- high-control internal pilots
- regulated environments where special handling must be explicit elsewhere
- proving that policy logic, not privileged wallets, owns enforcement

### Lockup and sanctions only

Use this when transfer size is not the risk vector, but timing and counterparties are.

Good for:
- vesting unlock schedules
- partner allocations
- employee or advisor distributions
- blacklist-only control surfaces

### Treasury emergency freeze

Use this as an emergency posture when something external changes fast and you need policy-level containment while preserving a treasury escape hatch.

Good for:
- incident response playbooks
- temporary containment pending investigation
- operational halt modes for compromised downstream integrations

---

## How to extend the cookbook

A new template should do all of the following:

1. express a clearly named posture
2. use only encoded values that the current integration actually forwards
3. describe *why* the posture exists, not just *what* it checks
4. include deterministic validation in this repo before being proposed upstream

When you add a new example:

- place the JSON file in `examples/policies/`
- run `npm run check:examples`
- run the Foundry and integration checks
- document the scenario in this file or in the examples README if the posture is materially different

---

## What to build next

If you want to turn this repo into a stronger developer on-ramp, the highest-ROI next steps are:

1. add an ERC721 / NFT guard companion repo
2. add a TypeScript / viem helper wrapper for policy selection and deployment
3. add a small browser-based policy playground for local simulation
4. add richer encoded signals (risk score, KYC tier, jurisdiction, market window)

That turns the repo from a single demo into a reusable Forte developer toolkit.
