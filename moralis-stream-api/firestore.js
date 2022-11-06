const { initializeApp, cert } = require('firebase-admin/app');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const serviceAccount = require('./credential.json');

initializeApp({ credential: cert(serviceAccount) });

module.exports = {
    db: getFirestore(),
    write: async function(collection, document, data, _merge) {
        try {
            const reference = this.db.collection(collection).doc(document);
            await reference.set(data, { merge: _merge })
            return true
        } catch (error) {
            console.log(error);
            return false
        }
    },
    updateNetworks: async function(collection, document, data) {
        try {
            const reference = this.db.collection(collection).doc(document)
            await reference.update({
                networks: FieldValue.arrayUnion(data)
            });
            return true
        } catch (error) {
            console.log(error);
            return false
        }
    }
}
