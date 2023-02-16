import { render } from '@testing-library/react';

import Home from './home';

describe('Home', () => {
    it('should render successfully', () => {
        const { baseElement } = render(<Home rand={0} />);
        expect(baseElement).toBeTruthy();
    });
});
