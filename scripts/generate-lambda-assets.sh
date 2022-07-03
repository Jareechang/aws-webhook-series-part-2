#!/bin/bash

echo "Generating assets for $MODULE."

pnpm --filter $MODULE install --prod --ignore-scripts --prefer-offline
pnpm --filter $MODULE create-deps
pnpm install
pnpm --filter $MODULE test
pnpm --filter $MODULE build

echo "Generating assets for $MODULE finished."
