# `elm-oembed`

A Web Component and accompanying Elm package for rendering [oembed content](https://oembed.com).

Width and height are sized dynamically based on the loaded content. Script tags are
safely loaded within an `iframe`.

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

## Setup
Just load the Web Component like so:

```shell
npm install --save-dev elm-oembed
```

```js
import "elm-oembed";
```
