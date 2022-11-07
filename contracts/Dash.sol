// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {IStableCoin} from "./stablecoins/IStableCoin.sol";
import {DashToken} from "./DashToken.sol";

contract Dash {
    address private deployer;
    uint private contractRevenue;
    uint public platformFee = 2; // 2% fee

    uint private userID;
    uint private liquidityID;
    uint private loanID;

    uint defaultCreditScore = 65;

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
        require(users[msg.sender].id == 0, "!already_created_an_account");

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

    function updateUser(
        string memory name,
        string memory photo,
        string memory email,
        string memory username,
        string memory year,
        string memory month,
        string memory phone,
        string memory homeAddress
    ) public {
        // verifies account exists
        require(users[msg.sender].id != 0, "no_account");

        // aware dependencies through event
        emit UserCreated(
            name,
            photo,
            email,
            username,
            msg.sender,
            users[msg.sender].creditScore,
            users[msg.sender].activeLoan,
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
        address provider,
        uint duration
    ) public {
        require(amount > 0, "!can_take_zero_token");

        int liquidityIndex = getUserLiquidityIndex(provider, id);
        require(liquidityIndex != -1, "!liquidity_exists");

        Liquidity memory liquidity = liquidities[provider][
            uint(liquidityIndex)
        ];
        int userNetworkIndex = getUserNetworkIndex(provider, msg.sender);

        // verifies the user is on provider contact list
        require(userNetworkIndex != -1, "!unathorized");

        // verifies user is not a loan before
        require(!users[msg.sender].activeLoan, "already_on_a_loan");

        // validate inputs with liquidity properties
        require(liquidity.amount >= amount, "insuficcient_pool");
        require(liquidity.maxTakeOut >= amount, "too_much");
        require(liquidity.minTakeOut <= amount, "too_little");
        require(liquidity.maxDays >= duration, "too_long");
        require(liquidity.minDays <= duration, "too_short");
        require(
            liquidity.minCreditScore <= users[msg.sender].creditScore,
            "too_low_credit_score"
        );

        // decrease the liquidity pool size
        liquidities[provider][uint(liquidityIndex)].amount -= amount;

        // user is now on a loan
        users[msg.sender].activeLoan = true;

        // create a new loan id
        loanID++;

        // create a new loan
        Loan memory loan = Loan(
            loanID,
            liquidity.id,
            amount,
            liquidity.tokenAddress,
            liquidity.interestRate,
            duration,
            provider,
            block.timestamp,
            0 // unpaid
        );

        // register the new loan
        loans[msg.sender].push(loan);

        // give out the loan
        // send tokens to user wallet
        IStableCoin token = IStableCoin(loan.tokenAddress);
        token.transfer(msg.sender, amount);

        // aware dependencies through event
        emit LoanCreated(
            loan.id,
            loan.liquidity,
            loan.amount,
            loan.duration,
            loan.interestRate,
            loan.createdAt,
            loan.paidAt,
            msg.sender
        );

        // aware dependencies through event
        emit UpdatedLiquidity(
            liquidity.id,
            liquidities[provider][uint(liquidityIndex)].amount
        );
    }

    function payLoan(uint id) public {
        int userLoanIndex = getUserLoanIndex(msg.sender, id);
        require(userLoanIndex != -1, "!loan_exists");

        Loan memory loan = loans[msg.sender][uint(userLoanIndex)];
        require(loan.paidAt == 0, "loan_already_paid");

        // pay interest
        uint secondsDiff = block.timestamp - loan.createdAt;
        uint daysElapsed = daysCount(secondsDiff);

        // calculate interest
        uint256 interest = calculateSimpleInterest(
            loan.interestRate,
            daysElapsed
        );

        // pay interest charges to smart contract in DASH tokens
        dashToken.approve(msg.sender, address(this), interest);
        dashToken.transferFrom(msg.sender, address(this), interest);

        // charge platform fee
        uint fee = (interest * (platformFee / 100));

        // pay interest profit to liquidity provider in DASH tokens
        dashToken.transfer(loan.provider, (interest - fee));

        // update platform profit
        contractRevenue += fee;

        // if liquidity still exists, add the funds back to the liquidty
        int liquidityIndex = getUserLiquidityIndex(
            loan.provider,
            loan.liquidity
        );

        if (liquidityIndex != -1) {
            // liquidity exists
            // pay loan to back smart contract
            IStableCoin token = IStableCoin(loan.tokenAddress);
            token.approve(msg.sender, address(this), loan.amount);
            token.transferFrom(msg.sender, address(this), loan.amount);

            // increase liquidity pool back
            liquidities[loan.provider][uint(liquidityIndex)].amount += loan
                .amount;

            // let dependecies knows pool has _changed_
            emit UpdatedLiquidity(
                loan.liquidity,
                liquidities[loan.provider][uint(liquidityIndex)].amount
            );
        } else {
            // else send the funds directly to the liquidity creator wallet
            IStableCoin token = IStableCoin(loan.tokenAddress);
            token.approve(msg.sender, loan.provider, loan.amount);
            token.transferFrom(msg.sender, loan.provider, loan.amount);
        }

        // mark loan as paid
        loan.paidAt = block.timestamp;

        // user is not on a loan anymore
        users[msg.sender].activeLoan = false;

        // credit score mechanism
        if (daysElapsed > loan.duration) {
            if (users[msg.sender].creditScore >= 5) {
                users[msg.sender].creditScore -= 5;
            } else {
                users[msg.sender].creditScore = 0;
            }
        } else {
            if (users[msg.sender].creditScore <= 95) {
                users[msg.sender].creditScore += 5;
            } else {
                users[msg.sender].creditScore = 100;
            }
        }

        // aware dependencies through event
        emit LoanCreated(
            loan.id,
            loan.liquidity,
            loan.amount,
            loan.duration,
            loan.interestRate,
            loan.createdAt,
            loan.paidAt,
            msg.sender
        );

        // aware dependencies through event
        emit CreditScoreChanged(msg.sender, users[msg.sender].creditScore);
    }

    function closeLiquidity(uint id) public {
        int liquidityIndex = getUserLiquidityIndex(msg.sender, id);

        // verifies the liquidty
        require(liquidityIndex != -1, "!you_do_own_these_liquidity");

        require(
            liquidities[msg.sender][uint256(liquidityIndex)].amount > 0,
            "insufficient_funds"
        );

        // send tokens to user wallet
        IStableCoin token = IStableCoin(
            liquidities[msg.sender][uint256(liquidityIndex)].tokenAddress
        );
        token.transfer(
            msg.sender,
            liquidities[msg.sender][uint256(liquidityIndex)].amount
        );

        // aware dependencies through event
        emit ClosedLiquidity(id);

        // remove liquidity
        delete liquidities[msg.sender][uint256(liquidityIndex)];
    }

    function provideLiquidity(
        uint256 amount,
        address tokenAddress,
        uint interestRate,
        uint256 minTakeOut,
        uint256 maxTakeOut,
        uint minDays,
        uint maxDays,
        uint minCreditScore
    ) public {
        // validates params
        require(minTakeOut < maxTakeOut, "invalid_take_out_values");
        require(minDays < maxDays, "invalid_days_values");
        require(minCreditScore <= 100, "invalid_credit_score_value");
        require(amount > 0, "invalid_amount_value");

        // create a new liquidity id
        liquidityID++;

        // creates and registers the liquidity
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
        IStableCoin token = IStableCoin(tokenAddress);
        token.approve(msg.sender, address(this), amount);
        token.transferFrom(msg.sender, address(this), amount);

        // aware dependencies through event
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

    function daysCount(uint _seconds) private pure returns (uint) {
        return (_seconds / (60 * 60 * 24));
    }

    // ====== interest calculator ====== //

    function calculateSimpleInterest(uint rate, uint duration)
        private
        pure
        returns (uint256)
    {
        // amount = capital(1 + (rate * duration))
        return (rate * duration);
    }

    // ======== events ========= //

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
    event CreditScoreChanged(address user, uint score);
    event NetworkAdded(address user, address by, bool isAdded);
    event LoanCreated(
        uint loanID,
        uint liquidityID,
        uint256 amount,
        uint duration,
        uint interestRate,
        uint createdAt,
        uint paidAt,
        address userAddress
    );
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
    event ClosedLiquidity(uint id);
    event UpdatedLiquidity(uint id, uint256 amount);
}
