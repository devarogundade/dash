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
                return ['string', 'string', 'string', 'string', 'address', 'uint', 'bool']
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
                    username: data[3],
                    score: data[5],
                    activeLoan: data[6]
                }
            default:
                return null
        }
    }
}