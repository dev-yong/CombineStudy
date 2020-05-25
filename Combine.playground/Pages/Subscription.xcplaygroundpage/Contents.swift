//: [Previous](@previous)
import Foundation
import Combine
/*:
 # Subscription
 
 - [`Subscriber`](Subscriber)와 [`Publisher`](Publisher) 간의 연결을 나타내는 프로토콜이다.
 - [`Subscription`](Subscription)은 `AnyCancellable` instance(Cancellation token)를 반환한다.
 - [`Subscribtion`](Subscription)의 취소는 thread-safe 해야 한다.
 */
protocol _Subscription : Cancellable, CustomCombineIdentifierConvertible {

    /// Subscriber가 해당 함수를 호출하여 `.max()` 혹은 `.unlimited`으로
    /// 더 많은 값을 받을 의사아 있음을 나타낸다.
    func request(_ demand: Subscribers.Demand)
}
//: [Next](@next)
