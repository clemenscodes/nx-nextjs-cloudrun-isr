// import next config in any page file to somehow make next aware of correct folder structure (MAGIC)
// see https://github.com/nrwl/nx/issues/9017#issuecomment-1284740346
import path from 'path';
path.resolve('./next.config.js');

export async function getStaticProps() {
    // get random number between 1 and 100
    const rand = Math.floor(Math.random() * 100);
    return {
        props: {
            rand,
        }, // will be passed to the page component as props
        revalidate: 30, // In seconds
    };
}

import { Home } from '@shared';
export default Home;
