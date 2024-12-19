import Combine
import Foundation

/// A sub-protocol of ``Publisher``, which adds no new functionality, but represents a promise
/// that this publisher will only ever fire on the main actor.
public protocol MainActorPublisher: Publisher {}

extension MainActorPublisher {
    /// Attaches a subscriber with closure-based behavior.
    ///
    /// Equivalent to ``Publisher/sink(receiveCompletion:receiveValue:)``, but with both
    /// closures marked as `@MainActor`.
    ///
    /// - parameter receiveComplete: The closure to execute on completion.
    /// - parameter receiveValue: The closure to execute on receipt of a value.
    /// - Returns: A cancellable instance, which you use when you end assignment of the received value. Deallocation of the result will tear down the subscription stream.
    @MainActor public func sinkOnMainActor(
        receiveCompletion: @escaping @MainActor (Subscribers.Completion<Failure>) -> Void,
        receiveValue: @escaping @MainActor (Output) -> Void
    ) -> AnyCancellable {
        sink(
            receiveCompletion: { completion in
                MainActor.assumeIsolated { receiveCompletion(completion) }
            },
            receiveValue: { value in
                MainActor.assumeIsolated { receiveValue(value) }
            }
        )
    }

    /// Attaches a subscriber with closure-based behavior to a publisher that never fails.
    ///
    /// Equivalent to ``Publisher/sink(receiveValue:)``, but with both
    /// closures marked as `@MainActor`.
    ///
    /// - parameter receiveValue: The closure to execute on receipt of a value.
    /// - Returns: A cancellable instance, which you use when you end assignment of the received value. Deallocation of the result will tear down the subscription stream.
    @MainActor public func sinkOnMainActor(
        receiveValue: @escaping @MainActor (Output) -> Void
    ) -> AnyCancellable where Failure == Never {
        sink { value in MainActor.assumeIsolated { receiveValue(value) } }
    }
}

extension Publishers.ReceiveOn: MainActorPublisher where Context == MainActorScheduler {}

extension Publisher {
    /// Create a ``MainActorPublisher`` that is guaranteed to deliver all elements on the main actor.
    ///
    /// If this publisher is already firing on the main actor, this operator is essentially
    /// a no-op, and elements will be delivered immediately without delay. If this publisher
    /// fires on a different thread, it will schedule the elements to be delivered on the
    /// main actor instead.
    ///
    /// - Returns: A ``MainActorPublisher`` that delivers elements on the main actor.
    @inlinable public func onMainActor() -> Publishers.ReceiveOn<Self, MainActorScheduler> {
        return receive(on: MainActorScheduler.shared)
    }
}

// TODO: Finish this list.
extension Publishers.Map: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.CompactMap: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.FlatMap: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.Filter: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.TryFilter: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.PrefixWhile: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.Scan: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.Concatenate: MainActorPublisher where Prefix: MainActorPublisher, Suffix: MainActorPublisher {}
extension Publishers.CombineLatest: MainActorPublisher where A: MainActorPublisher, B: MainActorPublisher {}
extension Publishers.CombineLatest3: MainActorPublisher where A: MainActorPublisher, B: MainActorPublisher, C: MainActorPublisher {}
extension Publishers.CombineLatest4: MainActorPublisher where A: MainActorPublisher, B: MainActorPublisher, C: MainActorPublisher, D: MainActorPublisher {}
extension Publishers.Zip: MainActorPublisher where A: MainActorPublisher, B: MainActorPublisher {}
extension Publishers.Zip3: MainActorPublisher where A: MainActorPublisher, B: MainActorPublisher, C: MainActorPublisher {}
extension Publishers.Zip4: MainActorPublisher where A: MainActorPublisher, B: MainActorPublisher, C: MainActorPublisher, D: MainActorPublisher {}
extension Publishers.Merge: MainActorPublisher where A: MainActorPublisher, B: MainActorPublisher {}
extension Publishers.Merge3: MainActorPublisher where A: MainActorPublisher, B: MainActorPublisher, C: MainActorPublisher {}
extension Publishers.Merge4: MainActorPublisher where A: MainActorPublisher, B: MainActorPublisher, C: MainActorPublisher, D: MainActorPublisher {}
extension Publishers.Merge5: MainActorPublisher where A: MainActorPublisher, B: MainActorPublisher, C: MainActorPublisher, D: MainActorPublisher, E: MainActorPublisher {}
extension Publishers.Merge6: MainActorPublisher where A: MainActorPublisher, B: MainActorPublisher, C: MainActorPublisher, D: MainActorPublisher, E: MainActorPublisher, F: MainActorPublisher {}
extension Publishers.Merge7: MainActorPublisher where A: MainActorPublisher, B: MainActorPublisher, C: MainActorPublisher, D: MainActorPublisher, E: MainActorPublisher, F: MainActorPublisher, G: MainActorPublisher {}
extension Publishers.Merge8: MainActorPublisher where A: MainActorPublisher, B: MainActorPublisher, C: MainActorPublisher, D: MainActorPublisher, E: MainActorPublisher, F: MainActorPublisher, G: MainActorPublisher, H: MainActorPublisher {}
extension Publishers.MergeMany: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.RemoveDuplicates: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.DropWhile: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.Drop: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.Output: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.Throttle: MainActorPublisher where Upstream: MainActorPublisher, Context == MainActorScheduler {}
extension Publishers.Debounce: MainActorPublisher where Upstream: MainActorPublisher, Context == MainActorScheduler {}
extension Publishers.Delay: MainActorPublisher where Upstream: MainActorPublisher, Context == MainActorScheduler {}
extension Publishers.Catch: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.Autoconnect: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.SetFailureType: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.HandleEvents: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.Timeout: MainActorPublisher where Upstream: MainActorPublisher, Context == MainActorScheduler {}
extension Publishers.TryMap: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.FirstWhere: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.ReplaceError: MainActorPublisher where Upstream: MainActorPublisher {}

extension Just: MainActorPublisher {}
extension Empty: MainActorPublisher {}
extension Fail: MainActorPublisher {}

extension MainActorPublisher {
    public func throttle(for interval: MainActorScheduler.SchedulerTimeType.Stride, latest: Bool = true) -> Publishers.Throttle<Self, MainActorScheduler> {
        return throttle(for: interval, scheduler: MainActorScheduler.shared, latest: latest)
    }

    public func debounce(for dueTime: MainActorScheduler.SchedulerTimeType.Stride) -> Publishers.Debounce<Self, MainActorScheduler> {
        return debounce(for: dueTime, scheduler: MainActorScheduler.shared)
    }

    public func delay(for interval: MainActorScheduler.SchedulerTimeType.Stride) -> Publishers.Delay<Self, MainActorScheduler> {
        return delay(for: interval, scheduler: MainActorScheduler.shared)
    }

    public func timeout(_ interval: MainActorScheduler.SchedulerTimeType.Stride, customError: (() -> Self.Failure)? = nil) -> Publishers.Timeout<Self, MainActorScheduler> {
        return timeout(interval, scheduler: MainActorScheduler.shared, customError: customError)
    }
}
