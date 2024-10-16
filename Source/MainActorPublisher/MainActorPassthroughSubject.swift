import Combine

public struct MainActorPassthroughSubject<Output, Failure: Error>: MainActorPublisher {
    private let passthroughSubject = PassthroughSubject<Output, Failure>()

    public init() {}

    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        passthroughSubject.receive(subscriber: subscriber)
    }

    @MainActor public func send(_ input: Output) {
        passthroughSubject.send(input)
    }

    @MainActor public func send() where Output == Void {
        passthroughSubject.send()
    }

    @MainActor public func send(completion: Subscribers.Completion<Failure>) {
        passthroughSubject.send(completion: completion)
    }
}
