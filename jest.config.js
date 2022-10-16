module.exports = {
  testEnvironment: "node",
  transform: {
    "^.+\\.(t|j)sx?$": ["@swc/jest"],
  },
  modulePathIgnorePatterns: ["examples/playwright/", "tests"],
};