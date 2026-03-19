// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IRulesEngine} from "@fortefoundation/forte-rules-engine/src/client/IRulesEngine.sol";

contract MockRulesEngine is IRulesEngine {
    function checkPolicies(bytes calldata arguments) external pure override {
        (
            address from,
            address to,
            uint256 value,
            uint256 blockTime,
            uint256 fromUnlockTime,
            uint256 fromBlacklistFlag,
            uint256 toBlacklistFlag,
            uint256 treasuryBypass,
            uint256 maxTransfer
        ) = abi.decode(
            arguments[4:],
            (address, address, uint256, uint256, uint256, uint256, uint256, uint256, uint256)
        );

        from;
        to;

        if (fromBlacklistFlag != 0 || toBlacklistFlag != 0) {
            revert("Blacklisted address");
        }

        if (treasuryBypass != 1 && value > maxTransfer) {
            revert("Transfer cap exceeded");
        }

        if (treasuryBypass != 1 && blockTime < fromUnlockTime) {
            revert("Tokens still locked");
        }
    }

    function grantCallingContractRole(address, address) external pure override returns (bytes32) {
        return bytes32(0);
    }

    function grantForeignCallAdminRole(address, address, bytes4) external pure override returns (bytes32) {
        return bytes32(0);
    }
}
