import Vue from "vue";
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getFirestore, collection, getDocs, doc, setDoc, getDoc, query, where, onSnapshot } from "firebase/firestore";

const firebaseConfig = {
    apiKey: "AIzaSyAKvW9kq_TItWuODqbmwwTUK9mu1c28QVc",
    authDomain: "dash-4f7dc.firebaseapp.com",
    projectId: "dash-4f7dc",
    storageBucket: "dash-4f7dc.appspot.com",
    messagingSenderId: "307654935620",
    appId: "1:307654935620:web:0fb6b6e1b6c2679b836811",
    measurementId: "G-24H9RHPRQ0"
};

const firebaseApp = initializeApp(firebaseConfig);
const analytics = getAnalytics(firebaseApp);

export default ({}, inject) => {
    inject('firestore', Vue.observable({
        db: getFirestore(firebaseApp),
        fetchAll: async function(_collection) {
            const result = []
            const snapshot = await getDocs(collection(this.db, _collection))

            snapshot.forEach(document => {
                result.push(document.data())
            });

            return result
        },
        fetchAllContacts: async function(address) {
            const result = []
            const user = await this.fetch('users', address)
            if (user == null) return result

            const networks = user.networks

            for (let index = 0; index < networks.length; index++) {
                const user = await this.fetch('users', networks[index])
                result.push(user)
            }

            return result
        },
        fetchAllContactsWithLiquidities: async function(address) {
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
        },
        fetchAllWhere: async function(_collection, key, sign, value) {
            const result = []

            const _query = query(collection(this.db, _collection), where(key, sign, value));
            const snapshot = await getDocs(_query)

            snapshot.forEach(document => {
                result.push(document.data())
            });

            return result
        },
        fetch: async function(_collection, _document) {
            const reference = doc(this.db, _collection, _document);
            const data = await getDoc(reference);

            if (data.exists()) {
                return data.data()
            } else {
                return null
            }
        },
        write: async function(_collection, _document, _object) {
            const reference = doc(this.db, _collection, _document)
            await setDoc(reference, _object)
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
