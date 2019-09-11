# `elm-oembed`

A Web Component and accompanying Elm package for rendering [oembed content](https://oembed.com).

## What is oembed

[`oembed` is a protocol](https://oembed.com), with [many providers implementing it](https://oembed.com/#section7).
It allows you to turn a URL into embeddable content.

These examples will render a YouTube player, an embedded Tweet, a Giphy `.gif` of the desired dimensions,
and an Elm code snippet in Ellie. Check out the `examples` folder to see it in action!

```elm
div []
    [ Oembed.viewOrDiscover Nothing "https://www.youtube.com/watch?v=43eM4kNbb6c"
    , Oembed.viewOrDiscover Nothing "https://twitter.com/dillontkearns/status/1105250778233491456"
    , Oembed.viewOrDiscover (Just { maxWidth = 250, maxHeight = 1000 }) "https://giphy.com/gifs/art-weird-ewan-26hiu3mZVquuykwhy"
    , Oembed.viewOrDiscover Nothing "https://ellie-app.com/4Xt4jdgtnZ2a1"
    ]
```








## Getting Started

### Install Dependencies

`npm install`

### Running Locally

`npm start`

Will compile your app and serve it from http://localhost:1234/
Changes to your source code will trigger a hot-reload in the browser, which
will also show compiler errors on build failures.

### Running Tests

`npm test`

or

`npm run autotest`

To re-run tests when files change.

### Production build

`npm run build`

Will generate a production-ready build of your app in the `dist` folder.

### Elm Commands

Elm binaries can be found in `node_modules/.bin`. They can be run from within
your project via  `npx`


To install new Elm packages, run:

`npx elm install <packageName>`

## Libraries & Tools

These are the main libraries and tools used to build elm-oembed-provider. If you're not
sure how something works, getting more familiar with these might help.

### [Elm](https://elm-lang.org)

Elm is a delightful language for creating reliable webapps. It guarantees no
runtime exceptions, and provides excellent performance. If you're not familiar
with it, [the official guide](https://guide.elm-lang.org) is a great place to get
started, and the folks on [Slack](https://elmlang.herokuapp.com) and
[Discourse](https://discourse.elm-lang.org) are friendly and helpful if you get
stuck.

### [Elm Test](https://package.elm-lang.org/packages/elm-exploration/test/latest)

This is the standard testing library for Elm. In addition to being useful for
traditional fixed-input unit tests, it also supports property-based testing
where random data is used to validate behavior over a large input space. It's
really useful!

### [Parcel](https://parceljs.org)

Parcel build and bundles the application's assets into individual HTML, CSS, and
JavaScript files. It also runs the live-server used during development.
