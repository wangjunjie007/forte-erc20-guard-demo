// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {console2} from "forge-std/console2.sol";
import {BlacklistOracle} from "src/BlacklistOracle.sol";
import {ForteGuardedToken} from "src/ForteGuardedToken.sol";

contract DeployDemo is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIV_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        uint256 maxTransfer = vm.envOr("MAX_TRANSFER_WEI", uint256(1000 ether));

        vm.startBroadcast(deployerPrivateKey);

        BlacklistOracle oracle = new BlacklistOracle(deployer);
        ForteGuardedToken token = new ForteGuardedToken(
            deployer,
            address(oracle),
            deployer,
            maxTransfer
        );

        token.mint(deployer, 10_000_000 ether);

        vm.stopBroadcast();

        console2.log("BlacklistOracle:", address(oracle));
        console2.log("ForteGuardedToken:", address(token));
        console2.log("Owner / Treasury:", deployer);
        console2.log("Max transfer:", maxTransfer);
    }
}
