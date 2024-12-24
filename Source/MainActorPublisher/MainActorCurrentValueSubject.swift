import Combine

/// A subject that wraps a single value and publishes a new element whenever the value changes.
///
/// Equivalent to `CurrentValueSubject` in Combine, but tagegd with `@MainActor` to enforce
/// only using it on the main actor.
public struct MainActorCurrentValueSubject<Output, Failure: Error>: MainActorPublisher {
    private let currentValueSubject: CurrentValueSubject<Output, Failure>

    /// Creates a current value subject with the given initial value.
    ///
    /// - Parameter value: The initial value to publish.
    public init(_ value: Output) {
        self.currentValueSubject = .init(value)
    }

    /// The value wrapped by this subject, published as a new element whenever it changes.
    @MainActor public var value: Output {
        get { currentValueSubject.value }
        set { currentValueSubject.value = newValue }
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        currentValueSubject.receive(subscriber: subscriber)
    }

    @MainActor public func send(_ input: Output) {
        currentValueSubject.send(input)
    }

    @MainActor public func send(completion: Subscribers.Completion<Failure>) {
        currentValueSubject.send(completion: completion)
    }
}
