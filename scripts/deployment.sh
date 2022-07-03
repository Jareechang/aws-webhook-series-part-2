#!/bin/bash

echo "Starting deployment on $MODULE."

pnpm --filter $MODULE install --prod --ignore-scripts --prefer-offline
pnpm --filter $MODULE create-deps
pnpm install
pnpm --filter $MODULE test
pnpm --filter $MODULE build

pnpm --filter $MODULE deploy

echo "Finish deployment on $MODULE."
