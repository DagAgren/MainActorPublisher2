import Combine

extension Publisher {
    /// Attaches a subscriber with closure-based behavior.
    ///
    /// Equivalent to ``Publisher/sink(receiveCompletion:receiveValue:)``, but with both
    /// closures correctly marked as `@Sendable` to make this safe to call without strict
    /// concurrency enabled.
    ///
    /// - parameter receiveComplete: The closure to execute on completion.
    /// - parameter receiveValue: The closure to execute on receipt of a value.
    /// - Returns: A cancellable instance, which you use when you end assignment of the received value. Deallocation of the result will tear down the subscription stream.
    public func sinkSendable(
        receiveCompletion: @escaping @Sendable (Subscribers.Completion<Failure>) -> Void,
        receiveValue: @escaping @Sendable (Output) -> Void
    ) -> AnyCancellable {
        return sink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
    }
}

extension Publisher where Failure == Never {
    /// Attaches a subscriber with closure-based behavior to a publisher that never fails.
    ///
    /// Equivalent to ``Publisher/sink(receiveValue:)``, but with both
    /// closures correctly marked as `@Sendable` to make this safe to call without strict
    /// concurrency enabled.
    ///
    /// - parameter receiveValue: The closure to execute on receipt of a value.
    /// - Returns: A cancellable instance, which you use when you end assignment of the received value. Deallocation of the result will tear down the subscription stream.
    public func sinkSendable(receiveValue: @escaping @Sendable (Output) -> Void) -> AnyCancellable {
        return sink(receiveValue: receiveValue)
    }
}
