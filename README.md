# Fluffypuppy
Your friendly AWS security auditor

This is a docker wrapper for the (Scout2)[https://github.com/nccgroup/Scout2] that makes it easier to scan multiple accounts at once.

[logo]: fluffypuppy.png

## Installation

`git clone fluffypuppy repo`

Edit `docker/flufypuppy/.aws/config` with your aws account details
Edit `docker/flufypuppy/.aws/credentials` with your aws IAM credentials

## Configuring AWS accounts
Edit terraform_role_policy/fluffypuppy_role_policy.tf with your IAM Account number and *apply* terraform_role_policy/fluffypuppy_role_policy.tf on all product accounts you would like to configure. This will apply a custom read-only policy that is required for Scout2.

## Running FluffyPuppy
`cd docker`
`docker-compose up`

The build time will take about 2 minute. A complete scan will take around 1-5 minutes - depending on how large your account is.

## Access Reports
http://localhost/index.html

Note: If you plan on having more than three accounts, you need to edit `docker/fluffypuppy/templates/accounts.html` with the `.aws/config` `profile name`.
