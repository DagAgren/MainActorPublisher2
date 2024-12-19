import Combine

/// A subject that broadcasts elements to downstream subscribers.
///
/// Equivalent to `PassthroughSubject` in Combine, but tagegd with `@MainActor` to enforce
/// only using it on the main actor.
public struct MainActorPassthroughSubject<Output, Failure: Error>: MainActorPublisher {
    private let passthroughSubject = PassthroughSubject<Output, Failure>()

    public init() {}

    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        passthroughSubject.receive(subscriber: subscriber)
    }

    @MainActor public func send(_ input: Output) {
        passthroughSubject.send(input)
    }

    /// Sends a value to the subscriber.
    ///
    /// - Parameter value: The value to send.
    @MainActor public func send() where Output == Void {
        passthroughSubject.send()
    }

    @MainActor public func send(completion: Subscribers.Completion<Failure>) {
        passthroughSubject.send(completion: completion)
    }
}
