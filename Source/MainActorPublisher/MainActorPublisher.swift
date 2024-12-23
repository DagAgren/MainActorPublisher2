import Combine
import Foundation

public protocol MainActorPublisher: Publisher {}

extension MainActorPublisher {
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

    @MainActor public func sinkOnMainActor(
        receiveValue: @escaping @MainActor (Output) -> Void
    ) -> AnyCancellable where Failure == Never {
        sink { value in MainActor.assumeIsolated { receiveValue(value) } }
    }
}

extension Publishers.ReceiveOn: MainActorPublisher where Context == UIScheduler2000 {}

extension Publisher {
    @inlinable public func onMainActor() -> Publishers.ReceiveOn<Self, UIScheduler2000> {
        return receive(on: UIScheduler2000.shared)
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
extension Publishers.Throttle: MainActorPublisher where Upstream: MainActorPublisher, Context == UIScheduler2000 {}
extension Publishers.Debounce: MainActorPublisher where Upstream: MainActorPublisher, Context == UIScheduler2000 {}
extension Publishers.Delay: MainActorPublisher where Upstream: MainActorPublisher, Context == UIScheduler2000 {}
extension Publishers.Catch: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.Autoconnect: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.SetFailureType: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.HandleEvents: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.Timeout: MainActorPublisher where Upstream: MainActorPublisher, Context == UIScheduler2000 {}
extension Publishers.TryMap: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.FirstWhere: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.ReplaceError: MainActorPublisher where Upstream: MainActorPublisher {}
extension Publishers.SwitchToLatest: MainActorPublisher where P: MainActorPublisher, Upstream: MainActorPublisher {}

extension Just: MainActorPublisher {}
extension Empty: MainActorPublisher {}
extension Fail: MainActorPublisher {}

extension MainActorPublisher {
    public func throttle(for interval: UIScheduler2000.SchedulerTimeType.Stride, latest: Bool = true) -> Publishers.Throttle<Self, UIScheduler2000> {
        return throttle(for: interval, scheduler: UIScheduler2000.shared, latest: latest)
    }

    public func debounce(for dueTime: UIScheduler2000.SchedulerTimeType.Stride) -> Publishers.Debounce<Self, UIScheduler2000> {
        return debounce(for: dueTime, scheduler: UIScheduler2000.shared)
    }

    public func delay(for interval: UIScheduler2000.SchedulerTimeType.Stride) -> Publishers.Delay<Self, UIScheduler2000> {
        return delay(for: interval, scheduler: UIScheduler2000.shared)
    }

    public func timeout(_ interval: UIScheduler2000.SchedulerTimeType.Stride, customError: (() -> Self.Failure)? = nil) -> Publishers.Timeout<Self, UIScheduler2000> {
        return timeout(interval, scheduler: UIScheduler2000.shared, customError: customError)
    }
}
