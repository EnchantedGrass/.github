# .github

## Reusable workflows for GitHub Actions

### [`reusable-gradle-build`](./.github/workflows/reusable-gradle-build.yml)

This workflow is designed to be used with Gradle projects.
It will build the project and upload the build artifacts as snapshot assets.

This workflow will pass `BUILD_VERSION` environment variable to the build command.
This variable is set to the value of `build-version` input.
If `build-version` input is not set, it will be set to the value of `github.ref` in short form.
The prefix `v` will be removed from the value of `build-version` before it is passed to the build command.

#### Usage

```yaml
build:
  uses: EnchantedGrass/.github/.github/workflows/reusable-gradle-build.yml@main
  with:
    java-version: 17 # optional, defaults to 17
    cache-read-only: false # optional, defaults to true if workflow is triggered in the main branch
    build-version: v1.0.0 # optional, defaults to ${{ github.ref }} in short form
    build-args: build # optional, defaults to "build"
    upload-artifacts: false # optional, defaults to true
    artifact-name: my-artifact # optional, defaults to "build-artifact"
    artifacts-path: build/libs # optional, defaults to "build/libs/*.jar"
```
