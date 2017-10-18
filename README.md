# PagerJudy

PagerJudy is:
- a Ruby SDK for PagerDuty
- with a handy built-in CLI tool

## Using it

It's published as a Docker image, at:

    registry.cowbell.realestate.com.au/cowbell/pagerjudy

Here's a handy shim script (save as `auto/pagerjudy`):

```shell
#! /bin/bash

PAGER_JUDY_IMAGE=registry.cowbell.realestate.com.au/cowbell/pagerjudy

exec docker run --rm -v $PWD:/cwd:ro -w /cwd \
  -e PAGER_DUTY_API_KEY \
  $PAGER_JUDY_IMAGE "$@"
```
