// Enforces Conventional Commits (https://www.conventionalcommits.org/) on every commit of a pull request:
// release-please reads them to make the release and its changelog, and a knowledge base pins a release.
module.exports = {
  extends: ["@commitlint/config-conventional"],
  rules: {
    // Dependabot's own commits pass: their subjects and release-notes bodies break only these two style rules.
    "subject-case": [0],
    "body-max-line-length": [0],
  },
};
