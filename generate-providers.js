#!/usr/bin/env node
const fs = require('fs');

providers = JSON.parse(fs.readFileSync('./providers.json').toString());

const mappedProviders =
  providers.map(provider => {
    return provider.endpoints.map(endpoint => {
        let url = endpoint.url.replace(/{format}/, 'json')
        // url: endpoint.url.replace(/{format}/, 'json'),
        let schemes = endpoint.schemes || []
      return `{ url = "${url}" }`
    })

  })

fs.writeFileSync('Providers.elm', `module Providers exposing (all)

-- type alias Provider

all =
  [   ${mappedProviders.join('\n    , ')}
  ]


`)
