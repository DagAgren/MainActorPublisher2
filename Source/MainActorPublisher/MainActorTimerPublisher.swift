import Foundation
import Combine

public struct MainActorTimerPublisher: ConnectablePublisher, MainActorPublisher {
    public typealias Output = Date
    public typealias Failure = Never

    private let timerPublisher: Timer.TimerPublisher

    public init(interval: TimeInterval, mode: RunLoop.Mode = .default) {
        self.timerPublisher = Timer.publish(every: interval, on: .main, in: mode)
    }

    public func connect() -> any Cancellable {
        return timerPublisher.connect()
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Date == S.Input {
        timerPublisher.receive(subscriber: subscriber)
    }

    public func autoconnect() -> Publishers.Autoconnect<Self> {
        return Publishers.Autoconnect(upstream: self)
    }
}
