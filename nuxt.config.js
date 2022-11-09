export default {
    ssr: false,

    target: 'static',

    env: {
        MNEMONIC: process.env.MNEMONIC,
        MORALIS_KEY: process.env.MORALIS_KEY,
        COVALENT_API_KEY: process.env.COVALENT_API_KEY,
        TOKEN_CONTRACT_ADDRESS: process.env.TOKEN_CONTRACT_ADDRESS,
        FTM_CONTRACT_ADDRESS: process.env.FTM_CONTRACT_ADDRESS,
        FIREBASE_API_KEY: process.env.FIREBASE_API_KEY,
        FIREBASE_AUTH_DOMAIN: process.env.FIREBASE_AUTH_DOMAIN,
        FIREBASE_PROJECT_ID: process.env.FIREBASE_PROJECT_ID,
        FIREBASE_STORAGE_BUCKET: process.env.FIREBASE_STORAGE_BUCKET,
        FIREBASE_MESSAGING_SENDER_ID: process.env.FIREBASE_MESSAGING_SENDER_ID,
        FIREBASE_APP_ID: process.env.FIREBASE_APP_ID,
        FIREBASE_MEASUREMENT_ID: process.env.FIREBASE_MEASUREMENT_ID
    },

    head: {
        title: 'Dash - Peer to Peer Lending',
        htmlAttrs: {
            lang: 'en'
        },
        meta: [
            { charset: 'utf-8' },
            { name: 'viewport', content: 'width=device-width, initial-scale=1' },
            { hid: 'description', name: 'description', content: '' },
            { name: 'format-detection', content: 'telephone=no' }
        ],
        link: [
            { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
            {}
        ]
    },

    css: [
        '@/static/common.css'
    ],

    plugins: [
        '@/plugins/auth.js',
        '@/plugins/ipfs.js',
        '@/plugins/utils.js',
        '@/plugins/covalent.js',
        '@/plugins/firestore.js',
        '@/plugins/contract.js',
        '@/plugins/faucet.js'
    ],

    components: [
        '~/components',
        '~/components/landing',
        '~/components/dapp',
        '~/components/pops'
    ],

    buildModules: [],

    modules: [
        '@nuxtjs/axios',
    ],

    axios: {
        baseURL: 'https://api.covalenthq.com/v1/', // covalent api base url
    },

    build: {
        extend(config, { isDev, isClient }) {
            config.node = {
                fs: 'empty',
                net: 'empty',
                express: 'empty'
            }
        }
    },
}