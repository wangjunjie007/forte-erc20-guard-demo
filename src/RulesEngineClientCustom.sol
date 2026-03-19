// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.24;

import {RulesEngineClient} from "@fortefoundation/forte-rules-engine/src/client/RulesEngineClient.sol";

abstract contract RulesEngineClientCustom is RulesEngineClient {
    modifier checkRulesBeforeTransfer(
        address from,
        address to,
        uint256 value,
        uint256 blockTime,
        uint256 fromUnlockTime,
        uint256 fromBlacklistFlag,
        uint256 toBlacklistFlag,
        uint256 treasuryBypass,
        uint256 maxTransfer
    ) {
        bytes memory encoded = abi.encodeWithSelector(
            msg.sig,
            from,
            to,
            value,
            blockTime,
            fromUnlockTime,
            fromBlacklistFlag,
            toBlacklistFlag,
            treasuryBypass,
            maxTransfer
        );
        _invokeRulesEngine(encoded);
        _;
    }

    modifier checkRulesBeforeTransferFrom(
        address from,
        address to,
        uint256 value,
        uint256 blockTime,
        uint256 fromUnlockTime,
        uint256 fromBlacklistFlag,
        uint256 toBlacklistFlag,
        uint256 treasuryBypass,
        uint256 maxTransfer
    ) {
        bytes memory encoded = abi.encodeWithSelector(
            msg.sig,
            from,
            to,
            value,
            blockTime,
            fromUnlockTime,
            fromBlacklistFlag,
            toBlacklistFlag,
            treasuryBypass,
            maxTransfer
        );
        _invokeRulesEngine(encoded);
        _;
    }
}
