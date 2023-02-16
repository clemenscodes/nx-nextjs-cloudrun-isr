import { AppProps } from 'next/app';
import Head from 'next/head';
import '../global.css';

const apexDomain = '';
const appName = '';
const prodCDN = `https://static.${appName}.${apexDomain}/public`;
const devCDN = `https://dev.static.${appName}.${apexDomain}/public`;
const isCloudRunProd = process.env.NEXT_PUBLIC_PROJECT_TYPE === 'production';
const isCloudRunDev = process.env.NEXT_PUBLIC_PROJECT_TYPE === 'development';
const isCloudRun = isCloudRunDev || isCloudRunProd;
const cloudRunAssetPrefix = isCloudRunProd ? prodCDN : devCDN;
const assetPrefix = isCloudRun ? cloudRunAssetPrefix : '';

function CustomApp({ Component, pageProps }: AppProps) {
    return (
        <>
            <Head>
                <title>Shop</title>
                <link rel='icon' href={`${assetPrefix}/favicon.ico`} />
            </Head>
            <main className='app'>
                <Component {...pageProps} />
            </main>
        </>
    );
}

export default CustomApp;
