//: [Previous](@previous)
import Foundation
import Combine
/*:
 # Subscription
 
 - [`Subscriber`](Subscriber)와 [`Publisher`](Publisher) 간의 연결을 나타내는 프로토콜이다.
 - `Cancellable`을 채택하기 때문에, `cancel()`을 호출할 수 있다.
 - [`Subscription`](Subscription)은 `AnyCancellable` instance(Cancellation token)를 반환한다.
 - [`Subscribtion`](Subscription)의 취소는 thread-safe 해야 한다.
 - [`Subscribtion`](Subscription)을 취소하면 [`Subscriber`](Subscriber)를 붙임으로써 할당되어졌던 resource들이 메모리에서 해제(free)된다.
 
 [Documentation](https://developer.apple.com/documentation/combine/subscription)
 */
protocol _Subscription : Cancellable {

    /// Subscriber가 해당 함수를 호출하여 `.max()` 혹은 `.unlimited`으로
    /// 더 많은 값을 받을 의사가 있음을 나타낸다.
    func request(_ demand: Subscribers.Demand)
}
example("Subscription") {
    let subscription = NotificationCenter.default.publisher(for: .custom, object: nil)
        .map { $0.object as? String ?? "" }
        .sink(receiveCompletion: {
            print("Received from a publisher, completion : \($0)")
        }, receiveValue: {
            print("Received from a publisher, value : \($0)")
        })
    NotificationCenter.default.post(name: .custom, object: "Hello Subscription")
    subscription.cancel()
    NotificationCenter.default.post(name: .custom, object: "It will never printed")
}
//: [Next](@next)
