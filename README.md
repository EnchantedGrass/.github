# .github

## Reusable workflows for GitHub Actions

### [`reusable-gradle-build`](./.github/workflows/reusable-gradle-build.yml)

This workflow is designed to be used with Gradle projects.
It will build the project and upload the build artifacts as snapshot assets.

#### Usage

```yaml
build:
  uses: EnchantedGrass/.github/.github/workflows/reusable-gradle-build.yml@main
  with:
    java-version: 17 # optional, defaults to 17
    build-args: build # optional, defaults to "build"
    upload-artifacts: false # optional, defaults to true
```
