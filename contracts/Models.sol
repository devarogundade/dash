// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Models {
    struct Liquidity {
        uint id;
        uint256 amount;
        address tokenAddress;
        uint interestRate;
        uint256 minTakeOut;
        uint256 maxTakeOut;
        uint minDays;
        uint maxDays;
        uint minCreditScore;
        uint createdAt;
    }

    struct Loan {
        uint id;
        uint liquidity;
        uint256 amount;
        address tokenAddress;
        uint interestRate;
        uint duration;
        address provider;
        uint createdAt;
        uint paidAt;
    }

    struct User {
        uint id;
        uint creditScore;
        bool activeLoan;
        uint createdAt;
        address[] networks;
    }
}
