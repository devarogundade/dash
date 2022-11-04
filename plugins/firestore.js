import Vue from "vue";
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getFirestore, collection, getDocs, doc, setDoc, getDoc, query, where, onSnapshot } from "firebase/firestore";

const firebaseConfig = {
    apiKey: "AIzaSyDkeL4TS_TVesr3rbtMHxo3ij_Ng9-lAxw",
    authDomain: "dash-3f37c.firebaseapp.com",
    projectId: "dash-3f37c",
    storageBucket: "dash-3f37c.appspot.com",
    messagingSenderId: "619398085989",
    appId: "1:619398085989:web:0f220076cad7a4cb90358c",
    measurementId: "G-70VPMTNN94"
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
        fetchAllWithCreator: async function(_collection) {
            const result = []
            const snapshot = await getDocs(collection(this.db, _collection))

            snapshot.forEach(document => {
                result.push(document.data())
            });

            for (let index = 0; index < result.length; index++) {
                result[index].creator = await this.fetch('users', result[index].address)
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
        fetchAllSubscribedCourses: async function(_address) {
            const subscriptions = await this.fetchAllWhere('subscriptions', 'address', '==', _address)

            for (let index = 0; index < subscriptions.length; index++) {
                subscriptions[index].course = await this.fetch('courses', subscriptions[index].courseId)
            }

            return subscriptions
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