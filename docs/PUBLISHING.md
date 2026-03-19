# Publishing Guide

This repository is prepared for public release, but publishing is still a deliberate final step.

## What is already cleaned up

- machine-specific absolute project paths removed from scripts
- local artifacts ignored via `.gitignore`
- English README added
- architecture and publishing docs added
- npm scripts added for a clean reviewer workflow

## Recommended pre-publish checklist

### 1. Verify locally one more time

```bash
npm install
forge install foundry-rs/forge-std --no-git
npm test
npm run check:integration
npm run check:policy
```

### 2. Confirm no sensitive files are staged

Do **not** publish:
- `.env`
- local logs
- local cache output
- temporary upstream clones

Check staged files carefully before first push.

### 3. Optional polish

Good additions if you want stronger public presentation:
- terminal GIF or short video
- architecture PNG exported from Mermaid
- badges for Foundry / license / CI after repo URL exists
- testnet deployment notes if you want external reviewers to interact with a live instance

### 4. Decide the repository posture

Choose one:
- code-only showcase
- interview / portfolio showcase
- Forte ecosystem demo repo
- base for future NFT / stablecoin / RWA policy demos

That choice will shape the final repo description and launch post.

## Suggested GitHub metadata

### Repository name
`forte-erc20-guard-demo`

### Short description
A practical ERC20 demo showing how to enforce transfer caps, blacklist checks, and lockups with Forte Rules Engine.

### Suggested topics
- forte
- rules-engine
- erc20
- solidity
- foundry
- compliance
- token-guard
- policy-engine

## Suggested launch angle

### Technical angle
“I built a guarded ERC20 where compliance controls live in Forte Rules Engine instead of being buried inside token code.”

### Product angle
“This repo demonstrates how to separate token plumbing from policy decisions: transfer caps, blacklists, and lockups all enforced through a policy-driven architecture.”

## Final gate

The repo is publishable from an engineering/documentation perspective.

The only final step that should remain a human decision is:
- whether to push it to a public GitHub repository, and where.
