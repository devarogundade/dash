export default {
    ssr: false,

    target: 'static',

    env: {
        MNEMONIC: process.env.MNEMONIC,
        MORALIS_KEY: process.env.MORALIS_KEY,
        COVALENT_API_KEY: process.env.COVALENT_API_KEY,
        TOKEN_CONTRACT_ADDRESS: process.env.TOKEN_CONTRACT_ADDRESS,
        FTM_CONTRACT_ADDRESS: process.env.FTM_CONTRACT_ADDRESS
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
        '@/plugins/stablecoins.js'
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
