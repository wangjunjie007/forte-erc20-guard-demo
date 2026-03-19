// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {RulesEngineClientCustom} from "src/RulesEngineClientCustom.sol";
import {BlacklistOracle} from "src/BlacklistOracle.sol";

contract ForteGuardedToken is ERC20, Ownable, RulesEngineClientCustom {
    BlacklistOracle public blacklistOracle;
    address public treasury;
    uint256 public maxTransfer;

    mapping(address => uint256) public lockUntil;

    event TreasuryUpdated(address indexed treasury);
    event BlacklistOracleUpdated(address indexed oracle);
    event MaxTransferUpdated(uint256 maxTransfer);
    event LockUntilUpdated(address indexed account, uint256 unlockTime);

    constructor(
        address initialOwner,
        address blacklistOracle_,
        address treasury_,
        uint256 maxTransfer_
    ) ERC20("Forte Guarded Token", "FGT") Ownable(initialOwner) {
        blacklistOracle = BlacklistOracle(blacklistOracle_);
        treasury = treasury_;
        maxTransfer = maxTransfer_;
    }

    function setCallingContractAdmin(address callingContractAdmin) public override onlyOwner {
        super.setCallingContractAdmin(callingContractAdmin);
    }

    function setBlacklistOracle(address blacklistOracle_) external onlyOwner {
        blacklistOracle = BlacklistOracle(blacklistOracle_);
        emit BlacklistOracleUpdated(blacklistOracle_);
    }

    function setTreasury(address treasury_) external onlyOwner {
        treasury = treasury_;
        emit TreasuryUpdated(treasury_);
    }

    function setMaxTransfer(uint256 maxTransfer_) external onlyOwner {
        maxTransfer = maxTransfer_;
        emit MaxTransferUpdated(maxTransfer_);
    }

    function setLockUntil(address account, uint256 unlockTime) external onlyOwner {
        lockUntil[account] = unlockTime;
        emit LockUntilUpdated(account, unlockTime);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function mintWithLock(address to, uint256 amount, uint256 unlockTime) external onlyOwner {
        _mint(to, amount);
        lockUntil[to] = unlockTime;
        emit LockUntilUpdated(to, unlockTime);
    }

    function transfer(address to, uint256 value)
        public
        override
        checkRulesBeforeTransfer(
            _msgSender(),
            to,
            value,
            block.timestamp,
            lockUntil[_msgSender()],
            _blacklistFlag(_msgSender()),
            _blacklistFlag(to),
            _treasuryBypass(_msgSender()),
            maxTransfer
        )
        returns (bool)
    {
        return super.transfer(to, value);
    }

    function transferFrom(address from, address to, uint256 value)
        public
        override
        checkRulesBeforeTransferFrom(
            from,
            to,
            value,
            block.timestamp,
            lockUntil[from],
            _blacklistFlag(from),
            _blacklistFlag(to),
            _treasuryBypass(from),
            maxTransfer
        )
        returns (bool)
    {
        return super.transferFrom(from, to, value);
    }

    function _blacklistFlag(address account) internal view returns (uint256) {
        if (address(blacklistOracle) == address(0)) {
            return 0;
        }
        return blacklistOracle.isBlacklisted(account) ? 1 : 0;
    }

    function _treasuryBypass(address from) internal view returns (uint256) {
        return from == treasury ? 1 : 0;
    }
}
