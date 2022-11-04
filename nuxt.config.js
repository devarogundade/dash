export default {
    ssr: false,

    target: 'static',

    head: {
        title: 'dash',
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
        '@/plugins/firestore.js',
        '@/plugins/contract.js'
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
        baseURL: 'https://deep-index.moralis.io/api/v2/', // moralis api base url
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