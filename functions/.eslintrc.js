module.exports = {
    root: true,
    env: {
        es6: true,
        node: true
    },
    extends: [
        `eslint:recommended`,
        `plugin:import/typescript`,
        `plugin:@typescript-eslint/eslint-recommended`,
        `plugin:@typescript-eslint/recommended`,
        `plugin:import/errors`,
        `plugin:import/warnings`,
        `prettier`
    ],
    parser: `@typescript-eslint/parser`,
    ignorePatterns: [`/lib/**/*`, `node_modules/**/*`],
    plugins: [`node`, `@typescript-eslint`, `import`],
    rules: {
        quotes: [`error`, `backtick`]
    },
    settings: {
        'import/resolver': {
            typescript: { project: `./` }
        }
    }
}
