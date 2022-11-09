import Vue from "vue";
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getFirestore, collection, getDocs, doc, setDoc, addDoc, getDoc, query, where, onSnapshot } from "firebase/firestore";

const dotenv = require("dotenv")
dotenv.config()

const firebaseConfig = {
    apiKey: process.env.FIREBASE_API_KEY,
    authDomain: process.env.FIREBASE_AUTH_DOMAIN,
    projectId: process.env.FIREBASE_PROJECT_ID,
    storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
    messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
    appId: process.env.FIREBASE_APP_ID,
    measurementId: process.env.FIREBASE_MEASUREMENT_ID,
};

const firebaseApp = initializeApp(firebaseConfig);
const analytics = getAnalytics(firebaseApp);

export default ({}, inject) => {
    inject('firestore', Vue.observable({
        db: getFirestore(firebaseApp),
        fetchAll: async function(_collection) {
            try {
                const result = []
                const snapshot = await getDocs(collection(this.db, _collection))

                snapshot.forEach(document => {
                    result.push(document.data())
                });

                return result
            } catch (error) {
                return []
            }
        },
        fetchAllContacts: async function(address) {
            try {
                const result = []
                const user = await this.fetch('users', address)
                if (user == null) return result

                const networks = user.networks

                for (let index = 0; index < networks.length; index++) {
                    const user = await this.fetch('users', networks[index])
                    result.push(user)
                }

                return result
            } catch (error) {
                return []
            }
        },
        fetchAllContactsWithLiquidities: async function(address) {
            try {
                const result = []

                const contacts = await this.fetchAllWhere(
                    'users',
                    'networks',
                    'array-contains',
                    address.toUpperCase()
                )

                for (let index = 0; index < contacts.length; index++) {
                    const liquidities = await this.fetchAllWhere(
                        'liquidities',
                        'address',
                        '==',
                        contacts[index].id.toUpperCase()
                    )

                    liquidities.forEach(liquidity => {
                        const _liquidity = liquidity
                        _liquidity.user = contacts[index]
                        result.push(liquidity)
                    })
                }

                return result
            } catch (error) {
                return []
            }
        },
        fetchAllLoans: async function(address) {
            try {
                const result = []

                const loans = await this.fetchAllWhere(
                    'loans',
                    'address',
                    '==',
                    address.toUpperCase()
                )

                for (let index = 0; index < loans.length; index++) {
                    const loan = loans[index]
                    const liquidity = await this.fetch('liquidities', loan.liquidityId)
                    loan.liquidity = liquidity
                    result.push(loan)
                }

                return result
            } catch (error) {
                return []
            }
        },
        fetchAllWhere: async function(_collection, key, sign, value) {
            try {
                const result = []

                const _query = query(collection(this.db, _collection), where(key, sign, value));
                const snapshot = await getDocs(_query)

                snapshot.forEach(document => {
                    result.push(document.data())
                });

                return result
            } catch (error) {
                return []
            }
        },
        fetch: async function(_collection, _document) {
            try {
                const reference = doc(this.db, _collection, _document);
                const data = await getDoc(reference);

                if (data.exists()) {
                    return data.data()
                } else {
                    return null
                }
            } catch (error) {
                return null
            }
        },
        fetchAllLoansHistoryProviders: async function(address) {
            try {
                const result = []

                const loans = await this.fetchAllWhere(
                    'loans',
                    'provider',
                    '==',
                    address.toUpperCase()
                )

                console.log(loans);

                for (let index = 0; index < loans.length; index++) {
                    const loan = loans[index]
                    const user = await this.fetch('users', loan.address)
                    const liquidity = await this.fetch('liquidities', loan.liquidityId)
                    loan.user = user
                    loan.liquidity = liquidity
                    result.push(loan)
                }

                return result
            } catch (error) {
                return []
            }
        },
        write: async function(_collection, _document, _object) {
            try {
                if (_document == null) {
                    await addDoc(collection(this.db, _collection), _object)
                    return true
                } else {
                    const reference = doc(this.db, _collection, _document)
                    await setDoc(reference, _object)
                    return true
                }
            } catch (error) {
                console.log(error);
                return false
            }
        },
        callback: function(_collection, _document) {
            const reference = doc(this.db, _collection, _document)

            onSnapshot(reference, (doc) => {
                const source = doc.metadata.hasPendingWrites ? "Local" : "Server";
                console.log(source, " data: ", doc.data());
            });
        }
    }))
}