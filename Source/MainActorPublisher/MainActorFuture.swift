import Combine

public struct MainActorFuture<Output, Failure: Error>: MainActorPublisher {
    public typealias Promise = @MainActor (Result<Output, Failure>) -> Void

    private let future: Future<Output, Failure>

    @MainActor public init(_ attemptToFulfill: @MainActor (@escaping Promise) -> Void) {
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
