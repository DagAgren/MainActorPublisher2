# MainActorPublisher

`MainActorPublisher` is a helper library to make working with Combine and Swift concurrency
(especially strict concurrency, as used in Swift 6) less painful.

## What is it?

`MainActorPublisher` is essentially just a marker protocol which inherits from `Publisher`,
and adds nothing else. It is meant as a promise that this `Publisher` will only
ever fire on the main actor.

## Why do I want this?

Combine is somewhat woefully unequipped to work together with strict concurrency. Especially
when working with UI code, which Combine is very often used for, we need to know on which
thread or actor the `Publisher` fires, and we need to flag our functions with `@MainActor` to
allow the compiler to enforce this. But Combine has no concept of this, and will let you
fire events on any thread, and trigger effects anywhere.

You can of course use operators that move execution to the main thread, but several
problems remain. First, the Swift compiler knows nothing about this, forcing you to use
unsafe constructs such as `MainActor.assumeIsolated()` to convince it code is safe.
Second, when working with UIKit, the concept of triggering code during the same runloop
becomes important in many cases, as animations can otherwise break, or you can introduce
subtle race conditions. The operators that move execution to the main thread will
usually delay execution to the next run loop, even in cases where execution is already
happening on the main thread.

Therefore, is nice to have a way to enforce that the entire chain of `Publisher` actions,
from triggering to `sink()` all happens on the main thread without delays. This is what
`MainActorPublisher` provides.

## How does this work?

The whole setup consists of three parts:

1. A set of wrappers for existing publishers that force them to only work on the main actor,
such as `MainActorPassthroughSubject`. This works exactly like `PassthroughSubject`, but
the `send()` method is marked as `@MainActor`.
2. A big list of extensions for types in `Publishers`, that lets the `MainActorPublisher`
propagate through the type system. For instance, if `Publishers.Map`'s `Upstream` type is a
`MainActorPublisher`, then it itself will aslo now conform to `MainActorPublisher`. This lets
you use most normal operators on `MainActorPublisher` while retaining the promise to only
fire on the main actor.
3. A set of helper functions to take advantage of this promise. Most importantly,
`MainActorPublisher` has a `.sinkOnMainActor()` whose closure is `@MainActor`.

There are also some other helpers, such as a re-implementation of `AnyPublisher`,
`AnyMainActorPublisher`, that is only available for `MainActorPublisher`s. There are also
some helper functions to convert a normal `Publisher` to a `MainActorPublisher`, either by
actually moving the execution to the main actor (`.onMainActor()`), or by promising that
it already is there (`.assumeIsolatedOnMainActor()`).

## But does it actually work?

Mostly. It's not quite perfect yet. The main thing missing is that `Publishers` contains
an awful lot of different types, and we've only added extensions for those we actually use
and the other most obvious ones. There are probably quite a few missing ones that still
need to be added, so do fire off a PR if you do!

## License

Copyright 2024 Wolt Enterprises Oy

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
