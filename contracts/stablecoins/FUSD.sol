// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {IStableCoin} from "./IStableCoin.sol";

contract FUSD is IStableCoin {
    address private deployer;

    uint256 private allocation = 5000 * 10**decimals();
    mapping(address => uint) private allocations;

    constructor(string memory name, string memory symbol) IStableCoin(name, symbol) {
        deployer = msg.sender;
        _mint(deployer, 1000000000000 * 10**decimals());
    }

    function faucetMint() public {
        require(allocations[msg.sender] < allocation, "!cant_mint_more_tokens");
        allocations[msg.sender] = allocation;
        approve(deployer, msg.sender, allocation);
        transferFrom(deployer, msg.sender, allocation);
    }
}
