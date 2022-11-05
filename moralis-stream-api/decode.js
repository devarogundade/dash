const Web3 = require('web3')

module.exports = {
    // converts EVM data to typeof array
    decode: function(format, value) {
        const web3 = new Web3()
        const data = web3.eth.abi.decodeParameters(format, value)
        return data
    },
    formats: function(collection) {
        // returns EVM event data formats
        switch (collection) {
            case 'users':
                return ['string', 'string', 'string', 'string', 'address', 'uint256', 'bool', 'string', 'string', 'string', 'string']
            case 'liquidities':
                return ['uint256', 'uint256', 'address', 'uint256', 'uint256', 'uint256', 'uint256', 'uint256', 'uint256', 'uint256', 'address']
            case 'loans':
                return ['uint256', 'uint256', 'uint256', 'uint256', 'uint256', 'uint256', 'uint256']
            case 'updated-liquidities':
                return ['uint256', 'uint256']
            case 'closed-liquidities':
                return ['uint']
            case 'networks':
                return ['address', 'address', 'bool']
            case 'credit-scores':
                return ['address', 'uint256']
            default:
                return null
        }
    },
    toObject: function(collection, data) {
        // each object must have a property of id
        switch (collection) {
            case 'users':
                return {
                    id: data[4].toUpperCase(), // avoid case sensitive
                    name: data[0],
                    photo: data[1],
                    email: data[2],
                    age: {
                        year: data[7],
                        month: data[8]
                    },
                    phone: data[9],
                    address: data[10],
                    username: data[3],
                    score: data[5],
                    activeLoan: data[6]
                }
            case 'liquidities':
                return {
                    id: data[0],
                    amount: data[1],
                    tokenAddress: data[2],
                    interestRate: data[3],
                    minTakeOut: data[4],
                    maxTakeOut: data[5],
                    minDays: data[6],
                    maxDays: data[7],
                    minScore: data[8],
                    address: data[9].toUpperCase()
                }
            case 'loans':
                return {
                    id: data[0],
                    liquidityId: data[1],
                    amount: data[2],
                    duration: data[3],
                    interestRate: data[4],
                    createdAt: data[5],
                    paidAt: data[6]
                }
            case 'updated-liquidities':
                return {
                    id: data[0],
                    amount: data[1]
                }
            case 'closed-liquidities':
                return {
                    id: data[0]
                }
            case 'networks':
                return {
                    id: data[0].toUpperCase(),
                    by: data[1].toUpperCase(),
                    isAdded: data[2]
                }
            case 'credit-scores':
                return {
                    id: data[0].toUpperCase(),
                    score: data[1]
                }
            default:
                return null
        }
    }
}