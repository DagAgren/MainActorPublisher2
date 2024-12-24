import Foundation
import Combine

/// A `Scheduler` implementation that always runs closures on the main actor.
///
/// If the execution is already taking place on the main actor, the code will be executed
/// immediately, with no delay, so this scheduler is safe to use when you need code to be
/// executed in the same runloop as it was invoked in.
///
/// This is similar to `ReactiveSwift`'s `UIScheduler`: https://reactivecocoa.io/reactiveswift/docs/latest/Classes/UIScheduler.html
public struct MainActorScheduler: Scheduler, Sendable {
    public typealias SchedulerOptions = Never
    public typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType

    public static let shared = Self()

    public var now: SchedulerTimeType { DispatchQueue.main.now }
    public var minimumTolerance: SchedulerTimeType.Stride { DispatchQueue.main.minimumTolerance }

    public func schedule(options: SchedulerOptions? = nil, _ action: @escaping () -> Void) {
        if Thread.isMainThread {
            action()
        } else {
            DispatchQueue.main.schedule(action)
        }
    }

    public func schedule(
        after date: SchedulerTimeType,
        tolerance: SchedulerTimeType.Stride,
        options: SchedulerOptions? = nil,
        _ action: @escaping () -> Void
    ) {
        DispatchQueue.main.schedule(after: date, tolerance: tolerance, options: nil, action)
    }

    public func schedule(
        after date: SchedulerTimeType,
        interval: SchedulerTimeType.Stride,
        tolerance: SchedulerTimeType.Stride,
        options: SchedulerOptions? = nil,
        _ action: @escaping () -> Void
    ) -> any Cancellable {
        DispatchQueue.main.schedule(
            after: date, interval: interval, tolerance: tolerance, options: nil, action
        )
    }
}
