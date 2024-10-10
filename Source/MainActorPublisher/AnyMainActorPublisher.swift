import Combine
import Foundation

extension MainActorPublisher {
    @inlinable public func eraseToAnyMainActorPublisher() -> AnyMainActorPublisher<Output, Failure> {
        return .init(self)
    }
}

extension Publisher {
    @inlinable public func assumeIsolatedOnMainActor() -> AnyMainActorPublisher<Output, Failure> {
        return .init(assumeIsolatedOnMainActor: self)
    }
}

public struct AnyMainActorPublisher<Output, Failure: Error>: CustomStringConvertible, CustomPlaygroundDisplayConvertible {
    private let box: PublisherBoxBase<Output, Failure>

    public init<PublisherType: MainActorPublisher>(_ publisher: PublisherType) where Output == PublisherType.Output, Failure == PublisherType.Failure {
        self.init(assumeIsolatedOnMainActor: publisher)
    }

    public init<PublisherType: Publisher>(assumeIsolatedOnMainActor publisher: PublisherType) where Output == PublisherType.Output, Failure == PublisherType.Failure {
        if let erased = publisher as? AnyMainActorPublisher<Output, Failure> {
            self.box = erased.box
        } else {
            self.box = PublisherBox(base: publisher)
        }
    }

    public var description: String { return "AnyMainActorPublisher" }
    public var playgroundDescription: Any { return description }
}

extension AnyMainActorPublisher: MainActorPublisher {
    public func receive<Downstream: Subscriber>(subscriber: Downstream) where Output == Downstream.Input, Failure == Downstream.Failure {
        box.receive(subscriber: subscriber)
    }
}

fileprivate class PublisherBoxBase<Output, Failure: Error> {
    init() {}

    func receive<Downstream: Subscriber>(subscriber: Downstream) where Failure == Downstream.Failure, Output == Downstream.Input { fatalError() }
}

fileprivate final class PublisherBox<PublisherType: Publisher>: PublisherBoxBase<PublisherType.Output, PublisherType.Failure> {
    let base: PublisherType

    init(base: PublisherType) {
        self.base = base
        super.init()
    }

    override func receive<Downstream: Subscriber>(subscriber: Downstream) where PublisherType.Failure == Downstream.Failure, PublisherType.Output == Downstream.Input {
        base.receive(subscriber: subscriber)
    }
}
