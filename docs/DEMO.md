# Demo Guide

This document gives you the fastest path to showing the repository in a public setting.

## 5-minute terminal demo

### 1. Install dependencies

```bash
npm install
forge install foundry-rs/forge-std --no-git
```

### 2. Rebuild the full local stack

```bash
npm run rebuild:local
```

Expected outcome:
- fresh anvil starts
- Forte Rules Engine deploys
- demo contracts deploy
- policy is created and applied
- live validation passes

### 3. Show the unit test suite

```bash
npm test
```

### 4. Show the integration proof

```bash
npm run check:integration
npm run check:policy
```

---

## Best live narrative

Use this order when presenting:

1. **Problem**  
   “Most tokens eventually need transfer restrictions, but hardcoding them inside the ERC20 makes the token rigid.”

2. **Architecture**  
   “This token stays readable. Policy decisions move into Forte Rules Engine.”

3. **Controls**  
   “This demo enforces a transfer cap, blacklist checks, and lockups, while treasury can bypass specific restrictions.”

4. **Proof**  
   “The repo does not just compile. It has Foundry unit tests and a full local integration rebuild that applies a real policy and exercises live transactions.”

5. **Scalability**  
   “The same pattern can extend to KYC, sanctions screening, RWA restrictions, marketplace rules, or staged rollout controls.”

---

## Suggested commands to paste during a live demo

### Run everything end to end

```bash
npm test && npm run check:integration && npm run check:policy
```

### Show that the token is guarded

The integration script will surface these behaviors:
- oversized transfer blocked
- blacklisted recipient blocked
- locked sender blocked
- unlocked sender succeeds

---

## Suggested closing line

> This repository turns policy enforcement into a first-class system component instead of burying it inside token code.
