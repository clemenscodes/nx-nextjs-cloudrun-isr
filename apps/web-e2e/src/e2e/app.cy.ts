import { getGreeting } from '../support/app.po';

describe('broshop', () => {
    beforeEach(() => cy.visit('/'));
    it('should display welcome message', () => {
        getGreeting().contains('Ready to dive in?');
    });
});
