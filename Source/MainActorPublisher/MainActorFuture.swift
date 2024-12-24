import Combine

/// A publisher that eventually produces a single value and then finishes or fails.
///
/// Equivalent to `Future` in Combine, but tagegd with `@MainActor` to enforce
/// only using it on the main actor.
public struct MainActorFuture<Output, Failure: Error>: MainActorPublisher {
    public typealias Promise = @MainActor (Result<Output, Failure>) -> Void

    private let future: Future<Output, Failure>

    /// Creates a publisher that invokes a promise closure when the publisher emits an element.
    @MainActor public init(_ attemptToFulfill: @MainActor (@escaping Promise) -> Void) {
        // Apparently the callback in Future.init will be called immediately from the
        // init function and not escape, even though it is marked as @escaping.
        // Here we assume this is happening and don't mark our version as @escaping,
        // and use `withoutActuallyEscaping()` to work around the incorrect labelling.
        self.future = withoutActuallyEscaping(attemptToFulfill) { attemptToFulfill in
            Future<Output, Failure> { promise in
                attemptToFulfill {
                    promise($0)
                }
            }
        }
    }

    public func receive<S>(subscriber: S) where Output == S.Input, Failure == S.Failure, S: Subscriber {
        future.receive(subscriber: subscriber)
    }
}
