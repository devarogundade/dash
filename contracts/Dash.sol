// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/iERC20.sol";

contract Dash {
    address private deployer;

    mapping(address => User) public users;
    mapping(uint => Transaction) public transactions;
    mapping(address => Balance[]) public balances;

    uint public platformFee = 1; // 1% fee

    struct User {
        string name;
        string username;
        uint createdAt;
    }

    struct Transaction {
        address from;
        address to;
        address tokenAddress;
        string message;
        uint256 amount;
        uint timestamp;
    }

    struct Balance {
        address tokenAddress;
        uint256 amount;
    }

    constructor() {
        deployer = msg.sender;
    }

    function send(
        address to,
        address tokenAddress,
        uint256 amount,
        string memory message
    ) public {
        uint timestamp = block.timestamp;

        require(amount > 0, "!can_send_zero_token");

        int senderBalanceIndex = getUserBalanceIndex(msg.sender, tokenAddress);
        int receiverBalanceIndex = getUserBalanceIndex(to, tokenAddress);

        require(senderBalanceIndex != -1, "!you_do_own_these_tokens");

        Balance memory senderBalance = balances[msg.sender][
            uint256(senderBalanceIndex)
        ];

        require(senderBalance.amount >= amount, "insuffieceint_funds");

        if (receiverBalanceIndex == -1) {
            // create balance for receiver
            balances[to].push(Balance(tokenAddress, 0));
            // balance is at last index
            receiverBalanceIndex = int(balances[to].length - 1);
        }

        Balance memory receiverBalance = balances[to][
            uint256(receiverBalanceIndex)
        ];

        // charge sender
        senderBalance.amount -= amount;

        // deduct platform fee
        uint paidAmount = amount * (platformFee / 100);

        // credit receiver
        receiverBalance.amount += paidAmount;

        emit NewTransaction(
            msg.sender,
            to,
            tokenAddress,
            message,
            amount,
            timestamp
        );
    }

    function withdraw(uint256 amount, address tokenAddress) public {
        int userBalanceIndex = getUserBalanceIndex(msg.sender, tokenAddress);
        require(userBalanceIndex != -1, "!you_do_own_these_tokens");

        Balance memory userBalance = balances[msg.sender][
            uint256(userBalanceIndex)
        ];
        require(userBalance.amount >= amount, "insuffieceint_funds");

        IERC20 token = IERC20(tokenAddress);

        // send tokens to user wallet
        token.transfer(msg.sender, amount);

        emit WithDraw(msg.sender, amount, tokenAddress);
    }

    function deposit(uint256 amount, address tokenAddress) public {
        int userBalanceIndex = getUserBalanceIndex(msg.sender, tokenAddress);

        if (userBalanceIndex == -1) {
            // create balance for receiver
            balances[msg.sender].push(Balance(tokenAddress, 0));
            // balance is at last index
            userBalanceIndex = int(balances[msg.sender].length - 1);
        }

        Balance memory userBalance = balances[msg.sender][
            uint256(userBalanceIndex)
        ];
        IERC20 token = IERC20(tokenAddress);

        // stake tokens from user wallet to the contract
        token.approve(address(this), amount);
        token.transferFrom(msg.sender, address(this), amount);

        userBalance.amount += amount;

        emit Deposit(msg.sender, amount, tokenAddress);
    }

    function getUserBalanceIndex(address user, address tokenAddress)
        private
        view
        returns (int)
    {
        Balance[] memory balanceList = balances[user];
        int position = -1;

        for (uint index = 0; index < balanceList.length; index++) {
            if (balanceList[index].tokenAddress == tokenAddress) {
                position = int(index);
                break;
            }
        }

        return position;
    }

    event NewTransaction(
        address from,
        address to,
        address tokenAddress,
        string message,
        uint256 amount,
        uint timestamp
    );
    event WithDraw(address user, uint256 amount, address tokenAddress);
    event Deposit(address user, uint256 amount, address tokenAddress);
}
