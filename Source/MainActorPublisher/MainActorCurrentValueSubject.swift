import Combine

public struct MainActorCurrentValueSubject<Output, Failure: Error>: Publisher {
    private let currentValueSubject: CurrentValueSubject<Output, Failure>

    public init(_ value: Output) {
        self.currentValueSubject = .init(value)
    }

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
