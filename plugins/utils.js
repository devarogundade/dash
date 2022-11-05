import Vue from "vue"
import Web3 from "web3"

export default ({}, inject) => {
    inject('utils', Vue.observable({
        web3Instance: new Web3(),
        fromWei: function(value) {
            try {
                const web3 = new Web3()
                return web3.utils.fromWei(value, 'ether')
            } catch (error) {}
        },
        toWei: function(value) {
            try {
                const web3 = new Web3()
                return web3.utils.toWei(value, 'ether')
            } catch (error) {
                console.log(error);
            }
        },
        formatToDate: function(timestamp) {
            const monthsInWord = [
                'January', 'February',
                'March', 'April',
                'May', 'June',
                'July', 'August',
                'September', 'October',
                'November', 'December'
            ]
            const date = new Date(timestamp)

            const day = parseInt(date.getUTCDate())
            const month = parseInt(date.getUTCMonth())
            const year = date.getUTCFullYear()

            return `${day} ${monthsInWord[month]} ${year}`
        }
    }))
}