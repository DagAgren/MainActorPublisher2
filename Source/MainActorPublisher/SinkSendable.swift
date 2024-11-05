import Combine

extension Publisher {
    public func sinkSendable(
        receiveCompletion: @escaping @Sendable (Subscribers.Completion<Failure>) -> Void,
        receiveValue: @escaping @Sendable (Output) -> Void
    ) -> AnyCancellable {
        return sink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
    }
}

extension Publisher where Failure == Never {
    public func sinkSendable(receiveValue: @escaping @Sendable (Output) -> Void) -> AnyCancellable {
        return sink(receiveValue: receiveValue)
    }
}
