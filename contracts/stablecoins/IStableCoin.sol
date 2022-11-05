// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract IStableCoin is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function approve(
        address owner,
        address spender,
        uint256 amount
    ) public {
        _approve(owner, spender, amount);
    }
}
