import React from 'react';
import type { ComponentStory, ComponentMeta } from '@storybook/react';
import Index from '../pages';

const Story: ComponentMeta<typeof Index> = {
    component: Index,
    title: 'Index',
};
export default Story;

const Template: ComponentStory<typeof Index> = () => <Index rand={3} />;

export const Primary = Template.bind({});
Primary.args = {};
