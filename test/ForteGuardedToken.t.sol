// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {BlacklistOracle} from "src/BlacklistOracle.sol";
import {ForteGuardedToken} from "src/ForteGuardedToken.sol";
import {MockRulesEngine} from "test/MockRulesEngine.sol";

contract ForteGuardedTokenTest is Test {
    BlacklistOracle internal oracle;
    ForteGuardedToken internal token;
    MockRulesEngine internal rulesEngine;

    address internal owner = address(0xA11CE);
    address internal alice = address(0xB0B);
    address internal bob = address(0xCAFE);
    address internal charlie = address(0xD00D);

    uint256 internal constant MAX_TRANSFER = 1_000 ether;

    function setUp() public {
        vm.startPrank(owner);
        oracle = new BlacklistOracle(owner);
        token = new ForteGuardedToken(owner, address(oracle), owner, MAX_TRANSFER);
        rulesEngine = new MockRulesEngine();

        token.setRulesEngineAddress(address(rulesEngine));
        token.setCallingContractAdmin(owner);

        token.mint(owner, 10_000 ether);
        token.transfer(alice, 3_000 ether);
        vm.stopPrank();
    }

    function testTransferWithinCapSucceeds() public {
        vm.prank(alice);
        token.transfer(bob, 100 ether);

        assertEq(token.balanceOf(alice), 2_900 ether);
        assertEq(token.balanceOf(bob), 100 ether);
    }

    function testTransferOverCapReverts() public {
        vm.prank(alice);
        vm.expectRevert(bytes("Transfer cap exceeded"));
        token.transfer(bob, 2_000 ether);
    }

    function testTransferToBlacklistedRecipientReverts() public {
        vm.prank(owner);
        oracle.setBlacklisted(bob, true);

        vm.prank(alice);
        vm.expectRevert(bytes("Blacklisted address"));
        token.transfer(bob, 1 ether);
    }

    function testTransferFromBlacklistedSenderReverts() public {
        vm.prank(owner);
        oracle.setBlacklisted(alice, true);

        vm.prank(alice);
        vm.expectRevert(bytes("Blacklisted address"));
        token.transfer(bob, 1 ether);
    }

    function testLockupBlocksTransferUntilUnlock() public {
        vm.prank(owner);
        token.setLockUntil(alice, block.timestamp + 1 hours);

        vm.prank(alice);
        vm.expectRevert(bytes("Tokens still locked"));
        token.transfer(bob, 1 ether);

        vm.prank(owner);
        token.setLockUntil(alice, 0);

        vm.prank(alice);
        token.transfer(bob, 10 ether);

        assertEq(token.balanceOf(bob), 10 ether);
    }

    function testTreasuryBypassesCapAndLockup() public {
        vm.startPrank(owner);
        token.setLockUntil(owner, block.timestamp + 1 days);
        token.transfer(bob, 2_000 ether);
        vm.stopPrank();

        assertEq(token.balanceOf(bob), 2_000 ether);
    }

    function testTransferFromWithinCapSucceeds() public {
        vm.prank(alice);
        token.approve(charlie, 500 ether);

        vm.prank(charlie);
        token.transferFrom(alice, bob, 500 ether);

        assertEq(token.balanceOf(alice), 2_500 ether);
        assertEq(token.balanceOf(bob), 500 ether);
    }

    function testTransferFromOverCapReverts() public {
        vm.prank(alice);
        token.approve(charlie, 2_000 ether);

        vm.prank(charlie);
        vm.expectRevert(bytes("Transfer cap exceeded"));
        token.transferFrom(alice, bob, 2_000 ether);
    }

    function testTransferFromRespectsLockup() public {
        vm.prank(owner);
        token.setLockUntil(alice, block.timestamp + 1 days);

        vm.prank(alice);
        token.approve(charlie, 100 ether);

        vm.prank(charlie);
        vm.expectRevert(bytes("Tokens still locked"));
        token.transferFrom(alice, bob, 100 ether);
    }

    function testTransferFromToBlacklistedRecipientReverts() public {
        vm.prank(owner);
        oracle.setBlacklisted(bob, true);

        vm.prank(alice);
        token.approve(charlie, 100 ether);

        vm.prank(charlie);
        vm.expectRevert(bytes("Blacklisted address"));
        token.transferFrom(alice, bob, 100 ether);
    }

    function testTransferFromFromBlacklistedSenderReverts() public {
        vm.prank(owner);
        oracle.setBlacklisted(alice, true);

        vm.prank(alice);
        token.approve(charlie, 100 ether);

        vm.prank(charlie);
        vm.expectRevert(bytes("Blacklisted address"));
        token.transferFrom(alice, bob, 100 ether);
    }

    function testRulesDisabledAllowsRawTransferBehavior() public {
        vm.prank(owner);
        token.setRulesEngineAddress(address(0));

        vm.prank(owner);
        oracle.setBlacklisted(bob, true);

        vm.prank(owner);
        token.setLockUntil(alice, block.timestamp + 1 days);

        vm.prank(alice);
        token.transfer(bob, 2_000 ether);

        assertEq(token.balanceOf(bob), 2_000 ether);
    }
}
