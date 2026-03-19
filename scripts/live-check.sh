#!/usr/bin/env bash
set -euo pipefail

if [[ -f "$HOME/.zshenv" ]]; then
  source "$HOME/.zshenv"
fi
source ./.env

RPC="${RPC_URL}"
TOKEN="${TOKEN_ADDRESS}"
ORACLE="${BLACKLIST_ORACLE_ADDRESS}"
OWNER_KEY="${PRIV_KEY}"
ALICE="0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
ALICE_KEY="0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d"
BOB="0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC"

ok(){ echo "[PASS] $1"; }
fail(){ echo "[FAIL] $1"; exit 1; }
expect_revert(){
  local name="$1"; shift
  set +e
  "$@" >/tmp/forte_cmd_out.txt 2>/tmp/forte_cmd_err.txt
  local code=$?
  set -e
  if [ $code -eq 0 ]; then
    echo "---- stdout ----"; cat /tmp/forte_cmd_out.txt || true
    echo "---- stderr ----"; cat /tmp/forte_cmd_err.txt || true
    fail "$name (expected revert but succeeded)"
  else
    ok "$name"
  fi
}

cast send "$TOKEN" "transfer(address,uint256)" "$ALICE" 3000000000000000000000 --rpc-url "$RPC" --private-key "$OWNER_KEY" >/dev/null
ok "owner -> alice 3000 transfer"

expect_revert "cap rule blocks alice->bob 2000" cast send "$TOKEN" "transfer(address,uint256)" "$BOB" 2000000000000000000000 --rpc-url "$RPC" --private-key "$ALICE_KEY"

cast send "$ORACLE" "setBlacklisted(address,bool)" "$BOB" true --rpc-url "$RPC" --private-key "$OWNER_KEY" >/dev/null
ok "set bob blacklisted=true"
expect_revert "blacklist rule blocks alice->blacklisted bob" cast send "$TOKEN" "transfer(address,uint256)" "$BOB" 1000000000000000000 --rpc-url "$RPC" --private-key "$ALICE_KEY"

cast send "$ORACLE" "setBlacklisted(address,bool)" "$BOB" false --rpc-url "$RPC" --private-key "$OWNER_KEY" >/dev/null
ok "set bob blacklisted=false"

NOW=$(cast block latest --rpc-url "$RPC" | awk '/timestamp/{print $2}')
UNLOCK=$((NOW+3600))
cast send "$TOKEN" "setLockUntil(address,uint256)" "$ALICE" "$UNLOCK" --rpc-url "$RPC" --private-key "$OWNER_KEY" >/dev/null
ok "set alice lockUntil future"
expect_revert "lockup rule blocks alice during lock" cast send "$TOKEN" "transfer(address,uint256)" "$BOB" 1000000000000000000 --rpc-url "$RPC" --private-key "$ALICE_KEY"

cast send "$TOKEN" "setLockUntil(address,uint256)" "$ALICE" 0 --rpc-url "$RPC" --private-key "$OWNER_KEY" >/dev/null
ok "unlock alice"
cast send "$TOKEN" "transfer(address,uint256)" "$BOB" 10000000000000000000 --rpc-url "$RPC" --private-key "$ALICE_KEY" >/dev/null
ok "alice -> bob 10 transfer after unlock"

ALICE_BAL=$(cast call "$TOKEN" "balanceOf(address)(uint256)" "$ALICE" --rpc-url "$RPC")
BOB_BAL=$(cast call "$TOKEN" "balanceOf(address)(uint256)" "$BOB" --rpc-url "$RPC")

echo "alice_balance=$ALICE_BAL"
echo "bob_balance=$BOB_BAL"
