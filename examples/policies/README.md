# Policy Templates

These example policy files turn the repo from a single demo into a small **policy cookbook** for Forte integrators.

## Included templates

- `retail-cap-with-treasury-bypass.policy.json`  
  Baseline posture for retail-facing ERC20s: blacklist checks, lockups, transfer caps, treasury bypass.

- `strict-no-exemptions.policy.json`  
  Applies the same cap and lockup rules to treasury and ops wallets too.

- `lockup-and-sanctions-only.policy.json`  
  Use Forte for vesting + blacklist enforcement, but do not enforce a transfer size cap.

- `treasury-emergency-freeze.policy.json`  
  Emergency template that blocks all non-treasury outgoing flow.

## How to try one

1. Copy a template over `policy/transfer-guard.policy.json`
2. Re-generate the integration layer:
   ```bash
   npm run generate:integration
   ```
3. Re-run validation:
   ```bash
   npm run check:examples
   npm test
   npm run check:integration
   npm run check:policy
   ```

For deeper notes and adaptation guidance, see `docs/POLICY_COOKBOOK.md`.
