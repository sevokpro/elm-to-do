const htmlWebpackPlugin = require('html-webpack-plugin');

module.exports = ()=>{
    const config = {
        entry: {
            index: `${__dirname}/app/src/index.js`
        },
        output: {
            path: `${__dirname}/app/dist/`,
            filename: '[name].js'
        },
        module: {
            rules: [{
                test: /\.elm$/,
                use: 'elm-webpack-loader'
            }]
        },
        plugins: [
            new htmlWebpackPlugin()
        ]
    }

    return config
}