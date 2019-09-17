## Combine

> The Combine framework provides a declarative Swift API for processing values over time. These values can represent many kinds of asynchronous events. Combine declares publishers to expose values that can change over time, and subscribers to receive those values from the publishers.
The Publisher protocol declares a type that can deliver a sequence of values over time. Publishers have operators to act on the values received from upstream publishers and republish them.
At the end of a chain of publishers, a Subscriber acts on elements as it receives them. Publishers only emit values when explicitly requested to do so by subscribers. This puts your subscriber code in control of how fast it receives events from the publishers it’s connected to.

## References:

- [Combine](https://developer.apple.com/documentation/combine)
- [Intro to Combine](https://developer.apple.com/videos/play/wwdc2019/722/)
- [Combine in Practice](https://developer.apple.com/videos/play/wwdc2019/721/)
