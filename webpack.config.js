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
            },{
                test: /\.css$/,
                use: [
                    `style-loader`,
                    `css-loader`
                ]
            },{
                test: /\.(svg|ttf|eot|woff(2)?)(\?[a-z0-9=&.]+)?$/,
                use: `file-loader`
            }]
        },
        plugins: [
            new htmlWebpackPlugin()
        ]
    }

    return config
}