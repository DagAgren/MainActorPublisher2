import Combine

public struct MainActorFuture<Output, Failure: Error>: MainActorPublisher {
    public typealias Promise = @MainActor (Result<Output, Failure>) -> Void

    private let future: Future<Output, Failure>

    public init(_ attemptToFulfill: @escaping (@escaping Promise) -> Void) {
        self.future = Future<Output, Failure> { promise in
            attemptToFulfill(promise)
        }
    }

    public func receive<S>(subscriber: S) where Output == S.Input, Failure == S.Failure, S: Subscriber {
        future.receive(subscriber: subscriber)
    }
}
