# Built with buck action

This action could be used to build some buck target

## Inputs

## `command`

**Required** The command to run. Default `"build"`.

## `target`

**Required** The name of the buck target.

## Outputs

## `artifact`

The result of the build.

## Example usage

uses: actions/build-with-buck@v1.0.0
with:
  target: 'application'