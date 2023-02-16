import { rootMain } from '../../.storybook/main';
import type { StorybookConfig, Options } from '@storybook/core-common';

const config: StorybookConfig = {
    ...rootMain,
    core: { ...rootMain.core, builder: 'webpack5' },
    stories: [
        ...rootMain.stories,
        '../web/stories/**/*.stories.?(ts|tsx|js|jsx)',
        '../../libs/shared/**/*.stories.@(js|jsx|ts|tsx|mdx)',
    ],
    addons: [
        ...(rootMain.addons || []),
        '@storybook/addon-essentials',
        '@storybook/addon-links',
        '@nrwl/react/plugins/storybook',
    ],
    webpackFinal: async (config, { configType }: Options) => {
        if (rootMain.webpackFinal) {
            config = await rootMain.webpackFinal(config, {
                configType,
            } as Options);
        }
        return config;
    },
};

module.exports = config;
