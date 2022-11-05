// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/iERC20.sol";
import {DashToken} from "./DashToken.sol";

contract Dash {
    address private deployer;
    uint private contractRevenue;
    uint public platformFee = 1; // 1% fee

    uint private userID;
    uint private liquidityID;
    uint private loanID;

    uint defaultCreditScore = 40;

    DashToken private dashToken;

    mapping(address => User) public users;
    mapping(address => Liquidity[]) public liquidities;
    mapping(address => Loan[]) public loans;

    constructor(address dashToken_) {
        deployer = msg.sender;
        dashToken = DashToken(dashToken_);
    }

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
        address from;
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

    function createUser(
        string memory name,
        string memory photo,
        string memory email,
        string memory username,
        string memory year,
        string memory month,
        string memory phone,
        string memory homeAddress
    ) public {
        // require(users[msg.sender].id == 0, "!already_created_an_account");

        userID++;
        users[msg.sender] = User(
            userID,
            defaultCreditScore,
            false,
            block.timestamp,
            users[msg.sender].networks
        );

        emit UserCreated(
            name,
            photo,
            email,
            username,
            msg.sender,
            defaultCreditScore,
            false,
            year,
            month,
            phone,
            homeAddress
        );
    }

    function addNetwork(address user) public {
        int userIndex = getUserNetworkIndex(msg.sender, user);
        if (userIndex == -1) {
            users[msg.sender].networks.push(user);
            emit NetworkAdded(user, msg.sender, true);
        }
    }

    function removeNetwork(address user) public {
        int userIndex = getUserNetworkIndex(msg.sender, user);
        if (userIndex != -1) {
            delete users[msg.sender].networks[uint(userIndex)];
            emit NetworkAdded(user, msg.sender, false);
        }
    }

    function takeLoan(
        uint id,
        uint256 amount,
        address owner,
        uint duration
    ) public {
        require(amount > 0, "!can_take_zero_token");
        int ownerLiquidityIndex = getUserLiquidityIndex(owner, id);
        require(ownerLiquidityIndex != -1, "!liquidity_exists");

        Liquidity memory liquidity = liquidities[owner][
            uint(ownerLiquidityIndex)
        ];

        int userNetworkIndex = getUserNetworkIndex(owner, msg.sender);
        require(userNetworkIndex != -1, "!unathorized");

        require(!users[msg.sender].activeLoan, "!already_on_a_loan");

        require(liquidity.amount >= amount, "insuficcient_pool");
        require(liquidity.maxTakeOut >= amount, "too_much");
        require(liquidity.minTakeOut <= amount, "too_little");
        require(liquidity.maxDays >= duration, "too_long");
        require(liquidity.minDays <= duration, "too_short");

        liquidity.amount -= amount;

        // user is now on a loan
        users[msg.sender].activeLoan = true;

        loanID++;
        loans[msg.sender].push(
            Loan(
                loanID,
                liquidity.id,
                amount,
                liquidity.tokenAddress,
                liquidity.interestRate,
                owner,
                block.timestamp,
                0
            )
        );

        emit TookLoan(loanID, amount, msg.sender, owner);
    }

    function payLoan(uint id, address owner) public {
        int userLoanIndex = getUserLoanIndex(msg.sender, id);
        require(userLoanIndex != -1, "!loan_exists");

        Loan memory loan = loans[msg.sender][uint(userLoanIndex)];
        require(loan.from == owner, "!unathorized");

        // pay interest
        uint durationInDays = ((block.timestamp - loan.createdAt) / 1 days);
        uint256 interest = calculateSimpleInterest(
            loan.interestRate,
            durationInDays
        );

        // pay to smart contract
        dashToken.approve(msg.sender, address(this), interest);
        dashToken.transferFrom(msg.sender, address(this), interest);

        // pay interest to liquidity provider
        // charge platform fee
        uint amount = (interest * (platformFee / 100));
        dashToken.transfer(msg.sender, amount);

        // update profit
        contractRevenue += (interest - amount);

        // if liquidity still exist, add the funds back to the liquidty
        int liquidityIndex = getUserLiquidityIndex(owner, loan.liquidity);

        if (liquidityIndex != -1) {
            // liquidity exists
            Liquidity memory liquidity = liquidities[owner][
                uint(liquidityIndex)
            ];

            // increase liquidity pool back
            liquidity.amount += amount;

            // pay loan to smart contract
            IERC20 token = IERC20(loan.tokenAddress);

            // token.approve(msg.sender, address(this), loan.amount);
            token.transferFrom(msg.sender, address(this), loan.amount);

            // let dependecies knows pool has _changed_
            emit UpdatedLiquidity(liquidity.id, liquidity.amount);
        } else {
            // else send the funds to the liquidity creator wallet
            IERC20 token = IERC20(loan.tokenAddress);

            // token.approve(msg.sender, owner, loan.amount);
            token.transferFrom(msg.sender, owner, loan.amount);
        }

        // mark loan as paid
        loan.paidAt = block.timestamp;

        // user is not on a loan
        users[msg.sender].activeLoan = false;

        emit PaidLoan(id, loan.amount, msg.sender, owner);
    }

    function closeLiquidity(uint id) public {
        int userLiquidityIndex = getUserLiquidityIndex(msg.sender, id);
        require(userLiquidityIndex != -1, "!you_do_own_these_tokens");

        Liquidity memory liquidity = liquidities[msg.sender][
            uint256(userLiquidityIndex)
        ];

        require(liquidity.amount > 0, "insuffieceint_funds");

        // send tokens to user wallet
        IERC20 token = IERC20(liquidity.tokenAddress);
        token.transfer(msg.sender, liquidity.amount);

        delete liquidity;

        emit ClosedLiquidity(liquidity.id);
    }

    function provideLiquity(
        uint256 amount,
        address tokenAddress,
        uint interestRate,
        uint256 minTakeOut,
        uint256 maxTakeOut,
        uint minDays,
        uint maxDays,
        uint minCreditScore
    ) public {
        liquidityID++;
        liquidities[msg.sender].push(
            Liquidity(
                liquidityID,
                amount,
                tokenAddress,
                interestRate,
                minTakeOut,
                maxTakeOut,
                minDays,
                maxDays,
                minCreditScore,
                block.timestamp
            )
        );

        // stake tokens from user wallet to the contract
        IERC20 token = IERC20(tokenAddress);
        // token.approve(msg.sender, owner, loan.amount);
        token.transferFrom(msg.sender, address(this), amount);

        emit ProvidedLiquity(
            liquidityID,
            amount,
            tokenAddress,
            interestRate,
            minTakeOut,
            maxTakeOut,
            minDays,
            maxDays,
            minCreditScore,
            block.timestamp,
            msg.sender
        );
    }

    function getUserLoanIndex(address user, uint id)
        private
        view
        returns (int)
    {
        Loan[] memory loanList = loans[user];
        int position = -1;

        for (uint index = 0; index < loanList.length; index++) {
            if (loanList[index].id == id) {
                position = int(index);
                break;
            }
        }

        return position;
    }

    function getUserLiquidityIndex(address user, uint id)
        private
        view
        returns (int)
    {
        Liquidity[] memory liquidityList = liquidities[user];
        int position = -1;

        for (uint index = 0; index < liquidityList.length; index++) {
            if (liquidityList[index].id == id) {
                position = int(index);
                break;
            }
        }

        return position;
    }

    function getUserNetworkIndex(address user, address network)
        private
        view
        returns (int)
    {
        address[] memory networks = users[user].networks;
        int position = -1;

        for (uint index = 0; index < networks.length; index++) {
            if (networks[index] == network) {
                position = int(index);
                break;
            }
        }

        return position;
    }

    function calculateSimpleInterest(uint rate, uint duration)
        private
        pure
        returns (uint256)
    {
        // amount = capital(1 + (rate * duration))
        return (rate * duration);
    }

    event UserCreated(
        string name,
        string photo,
        string email,
        string username,
        address userAddress,
        uint creditScore,
        bool activeLoan,
        string year,
        string month,
        string phone,
        string homeAddress
    );
    event NetworkAdded(address user, address by, bool isAdded);
    event TookLoan(uint id, uint256 amount, address userAddress, address owner);
    event PaidLoan(uint id, uint256 amount, address userAddress, address owner);
    event ClosedLiquidity(uint id);
    event UpdatedLiquidity(uint id, uint256 amount);
    event ProvidedLiquity(
        uint liquidityID,
        uint256 amount,
        address tokenAddress,
        uint interestRate,
        uint256 minTakeOut,
        uint256 maxTakeOut,
        uint minDays,
        uint maxDays,
        uint minCreditScore,
        uint createdAt,
        address userAddress
    );
}
