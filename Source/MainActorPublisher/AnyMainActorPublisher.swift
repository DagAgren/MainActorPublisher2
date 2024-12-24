import Combine
import Foundation

extension MainActorPublisher {
    /// Wraps this publisher with a type eraser.
    ///
    /// This is similar to ``Publisher/eraseToAnyPublisher()``.
    ///
    /// - Returns: An ``AnyMainActorPublisher`` wrapping this publisher.
    @inlinable public func eraseToAnyMainActorPublisher() -> AnyMainActorPublisher<Output, Failure> {
        return .init(self)
    }
}

extension Publisher {
    /// Wraps this publisher with a type eraser that assumes this publisher will only ever fire on the main actor.
    ///
    /// It is important to get this right, as getting it wrong will cause a crash.
    ///
    /// - Returns: An ``AnyMainActorPublisher`` wrapping this publisher.
    @inlinable public func assumeIsolatedOnMainActor() -> AnyMainActorPublisher<Output, Failure> {
        return .init(assumeIsolatedOnMainActor: self)
    }
}

/// A publisher that performs type erasure by wrapping another ``MainActorPublisher``.
///
/// This is similar to ``AnyPublisher``.
///
/// You can use ``MainActorPublisher/eraseToAnyMainActorPublisher()`` operator to wrap a ``MainActorPublisher`` with ``AnyMainActorPublisher``.
///
/// You can also use ``MainActorPublisher/assumeIsolatedOnMainActor()`` operator to wrap a regular ``Publisher`` with ``AnyMainActorPublisher`` if you know for sure it will only ever trigger on the main thread. Getting this wrong will cause a crash, however.
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
