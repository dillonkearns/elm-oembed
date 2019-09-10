#!/usr/bin/env node
const fs = require('fs');

providers = JSON.parse(fs.readFileSync('./providers.json').toString());

const mappedProviders =
  providers.map(provider => {
    return provider.endpoints.map(endpoint => {
        let url = endpoint.url.replace(/{format}/, 'json')
        if (url.includes('*')) {
          console.log(url);
        }
        let schemes = endpoint.schemes || []
      return `{ url = "${url}"
    , schemes = [ ${schemes.map(escapeScheme).map(scheme => `regex ${JSON.stringify(scheme)}`)} ]
}`
    })

  })

function escapeScheme(scheme) {
  return scheme.replace(/\?/, '\\?')
  .replace(/\./g, '\\.')
  .replace(/\*/g, '.*')

}

fs.writeFileSync('src/Oembed/Provider.elm', `module Oembed.Provider exposing (Provider, all, lookup)

import List.Extra
import Regex exposing (Regex)

lookup : String -> Maybe String
lookup inputUrl =
    all
        |> List.Extra.find
            (\\provider ->
                provider.schemes
                    |> List.any (\\scheme -> Regex.contains scheme inputUrl)
            )
        |> Maybe.map .url


type alias Provider =
    { schemes : List Regex
    , url : String
    }


regex : String -> Regex
regex string =
    string
        |> Regex.fromString
        |> Maybe.withDefault Regex.never

all : List Provider
all =
  [   ${mappedProviders.join('\n    , ')}
  ]


`)
