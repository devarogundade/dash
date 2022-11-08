// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {IStableCoin} from "./stablecoins/IStableCoin.sol";
import {DashToken} from "./DashToken.sol";
import {Models} from "./Models.sol";

import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Dash {
    using SafeMath for uint256;

    address private deployer;
    uint private contractRevenue;

    /*
      We charge a 5% fee on every interest a liquidity provider earned from giving out a loan.
    */
    uint public platformFee = 5; // 5% fee

    uint private userID;
    uint private liquidityID;
    uint private loanID;

    /*
    Default credit score of a user is 65
    When they do well on the platfrom by paying back loans on time
    their credit score will increase by 2 otherwise will decrease by 5
    */
    uint defaultCreditScore = 65;

    /*
    DASH is the native cryptocurrency of the platform, it is use for paying loan interests.
    */
    DashToken private dashToken;

    mapping(address => Models.User) public users;
    mapping(address => Models.Liquidity[]) public liquidities;
    mapping(address => Models.Loan[]) public loans;

    constructor(address dashToken_) {
        deployer = msg.sender;
        dashToken = DashToken(dashToken_);
    }

    /*
    We are using moralis stream to pick up user creation events and
    sync the data to our firebase backend.
    */
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

        // create a new id
        userID++;

        users[msg.sender] = Models.User(
            userID,
            defaultCreditScore,
            false,
            block.timestamp,
            users[msg.sender].networks
        );

        // aware dependencies
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
    ) public onlyUser {
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

    /* adding a new contact */
    function addNetwork(address user) public onlyUser {
        int userIndex = getUserNetworkIndex(msg.sender, user);
        if (userIndex == -1) {
            users[msg.sender].networks.push(user);
            emit NetworkAdded(user, msg.sender, true);
        }
    }

    /* removing an existing contact */
    function removeNetwork(address user) public onlyUser {
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
    ) public onlyUser {
        require(amount > 0, "You can't borrow zero tokens");

        int liquidityIndex = getUserLiquidityIndex(provider, id);
        require(liquidityIndex != -1, "Liquidity does not exists");

        Models.Liquidity memory liquidity = liquidities[provider][
            uint(liquidityIndex)
        ];
        int userNetworkIndex = getUserNetworkIndex(provider, msg.sender);

        // verifies the user is on provider contact list
        require(
            userNetworkIndex != -1,
            "You are not on provider's contact list"
        );

        // verifies user is not a loan before
        require(!users[msg.sender].activeLoan, "You are already on a loan");

        // validate loan and user inputs with liquidity properties
        require(liquidity.amount >= amount, "Insufficient pool size");
        require(
            liquidity.maxTakeOut >= amount,
            "Amount is greater than maximum take out"
        );
        require(
            liquidity.minTakeOut <= amount,
            "Amount is lesser than minimum take out"
        );
        require(
            liquidity.maxDays >= duration,
            "Duration is longer than maximum duration"
        );
        require(
            liquidity.minDays <= duration,
            "Duration is shorter than minimum duration"
        );
        require(
            liquidity.minCreditScore <= users[msg.sender].creditScore,
            "Your credit score is too low"
        );

        // decrease the liquidity pool size
        liquidities[provider][uint(liquidityIndex)].amount -= amount;

        // user is now on a loan
        users[msg.sender].activeLoan = true;

        // create a new loan id
        loanID++;

        // create a new loan
        Models.Loan memory loan = Models.Loan(
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
            msg.sender,
            loan.provider
        );

        // aware dependencies through event
        emit UpdatedLiquidity(
            liquidity.id,
            liquidities[provider][uint(liquidityIndex)].amount
        );
    }

    function payLoan(uint id) public onlyUser {
        int userLoanIndex = getUserLoanIndex(msg.sender, id);
        require(userLoanIndex != -1, "!loan_exists");

        Models.Loan memory loan = loans[msg.sender][uint(userLoanIndex)];
        require(loan.paidAt == 0, "loan_already_paid");

        // pay interest
        uint secondsDiff = block.timestamp - loan.createdAt;

        // calculate interest
        uint256 interest = ((loan.interestRate * secondsDiff) / 1 days);

        // pay interest charges to smart contract in DASH tokens
        dashToken.approve(msg.sender, address(this), interest);
        dashToken.transferFrom(msg.sender, address(this), interest);

        // charge platform fee
        uint fee = ((interest * platformFee) / 100);

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
        uint duration = (loan.duration * 1 days);
        if (block.timestamp > SafeMath.add(loan.createdAt, duration)) {
            // user has default, so their credit score is deducted by 5
            if (users[msg.sender].creditScore >= 5) {
                users[msg.sender].creditScore -= 5;
            } else {
                users[msg.sender].creditScore = 0;
            }
        } else {
            // user repays on time so their credit score is increased by 2
            if (users[msg.sender].creditScore <= 98) {
                users[msg.sender].creditScore += 2;
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
            msg.sender,
            loan.provider
        );

        // aware dependencies through event
        emit CreditScoreChanged(msg.sender, users[msg.sender].creditScore);
    }

    function closeLiquidity(uint id) public onlyUser {
        int liquidityIndex = getUserLiquidityIndex(msg.sender, id);

        // verifies the liquidty
        require(liquidityIndex != -1, "You do not own this liquidity");

        if (liquidities[msg.sender][uint256(liquidityIndex)].amount > 0) {
            // send left over tokens to back to the provider's wallet
            IStableCoin token = IStableCoin(
                liquidities[msg.sender][uint256(liquidityIndex)].tokenAddress
            );
            token.transfer(
                msg.sender,
                liquidities[msg.sender][uint256(liquidityIndex)].amount
            );
        }

        // remove liquidity
        delete liquidities[msg.sender][uint256(liquidityIndex)];

        // aware dependencies through event
        emit ClosedLiquidity(id);
    }

    /* provide liquidity */
    function provideLiquidity(
        uint256 amount,
        address tokenAddress,
        uint interestRate,
        uint256 minTakeOut,
        uint256 maxTakeOut,
        uint minDays,
        uint maxDays,
        uint minCreditScore
    ) public onlyUser {
        // validates params
        require(amount > 0, "Amount cannot be zero");
        require(
            minTakeOut <= maxTakeOut,
            "Minimum take oit cannot be greater than maximum take out"
        );
        require(
            maxTakeOut <= amount,
            "Maximun take out cannot be greater than amount"
        );
        require(
            minDays <= maxDays,
            "Minimum duration cannot be greater than maximum duration"
        );
        require(minCreditScore <= 100, "Credit scrore is too high, Max is 100");

        // create a new liquidity id
        liquidityID++;

        // creates and registers the liquidity
        liquidities[msg.sender].push(
            Models.Liquidity(
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

    // ========= helper functions

    function getUserLoanIndex(address user, uint id)
        private
        view
        returns (int)
    {
        Models.Loan[] memory loanList = loans[user];
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
        Models.Liquidity[] memory liquidityList = liquidities[user];
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

    /* deployer to cashout earnings */
    function withdrawPlatformFee(uint256 amount) public onlyDeployer {
        require(contractRevenue >= amount, "insuficcient tokens");
        contractRevenue -= amount;
        dashToken.transfer(deployer, amount);
    }

    /* deployer to change deployer */
    function changeDeployer(address _address) public onlyDeployer {
        require(_address != address(0), "Invalid address");
        deployer = _address;
    }

    /* deployer to change platfrom fee */
    function changeDeployer(uint percentage) public onlyDeployer {
        require(percentage <= 100, "Percentage is too high");
        platformFee = percentage;
    }

    // ====== interest calculator ====== //

    function calculateSimpleInterest(uint rate, uint duration)
        private
        pure
        returns (uint256)
    {
        return SafeMath.mul(rate, duration);
    }

    // ======= modifiers ======== //

    modifier onlyUser() {
        /* only registered user */
        require(users[msg.sender].id != 0, "Create an account first");
        _;
    }

    modifier onlyDeployer() {
        /* only account that deployed the contract */
        require(msg.sender == deployer, "You are not authorized");
        _;
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
        address userAddress,
        address provider
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
