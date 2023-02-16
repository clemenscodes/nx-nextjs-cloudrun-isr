const { join } = require('path');
const { withNx } = require('@nrwl/next/plugins/with-nx');

const apexDomain = '';
const appName = '';
const prodCDN = `https://static.${appName}.${apexDomain}`;
const devCDN = `https://dev.static.${appName}.${apexDomain}`;
const isCloudRunProd = process.env.NEXT_PUBLIC_PROJECT_TYPE === 'production';
const isCloudRunDev = process.env.NEXT_PUBLIC_PROJECT_TYPE === 'development';
const isCloudRun = isCloudRunDev || isCloudRunProd;
const cloudRunAssetPrefix = isCloudRunProd ? prodCDN : devCDN;
const assetPrefix = isCloudRun ? cloudRunAssetPrefix : undefined;

/**
 * @type {import('@nrwl/next/plugins/with-nx').WithNxOptions}
 **/
const nextConfig = {
    output: 'standalone',
    assetPrefix: assetPrefix,
    swcMinify: true,
    experimental: {
        outputFileTracingRoot: join(__dirname, '../../'),
        isrMemoryCacheSize: 0,
    },
    images: {
        unoptimized: true,
    },
    reactStrictMode: true,
    nx: {
        // Set this to true if you would like to to use SVGR
        // See: https://github.com/gregberge/svgr
        svgr: true,
    },
    webpack(config) {
        config.module.rules.push({
            test: /index\.(js|mjs|jsx|ts|tsx)$/,
            sideEffects: false,
        });
        return config;
    },
};

module.exports = withNx(nextConfig);
