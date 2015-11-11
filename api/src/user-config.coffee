require.config(
    baseUrl: '/assets/src'
    waitSeconds: 0
    paths:
        'lodash': '../vendor/lodash.compat.min'
    shim:
        'lodash': 
            exports: '_'
)