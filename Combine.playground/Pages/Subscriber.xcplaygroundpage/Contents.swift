//: [Previous](@previous)
import Foundation
import Combine
/*:
 # Subscriber
 
 - [`Subscriber`](Subscriber) instance는 [`Publisher`](Publisher)가 emit하는 element stream을 받는다.
 - `Subscriber.Input`, `Subscriber.Failure`는 `Publisher.Output`, `Publisher.Failure`과 알맞아야 한다.
 
 [Documentation](https://developer.apple.com/documentation/combine/subscriber)
*/
protocol _Subscriber {

    associatedtype Input
    associatedtype Failure: Error

    /// Tells the subscriber that it has successfully subscribed to the publisher and may request items.
    ///
    /// Use the received `Subscription` to request items from the publisher.
    func receive(subscription: Subscription)

    /// Tells the subscriber that the publisher has produced an element.
    func receive(_ input: Self.Input) -> Subscribers.Demand

    /// Tells the subscriber that the publisher has completed publishing, either normally or with an error.
    func receive(completion: Subscribers.Completion<Self.Failure>)
}
/*:
 ## Operator로 제공되어지는 Subscriber
 - `sink(receiveCompletion:, receiveValue:)`
   - Closure 기반 동작으로 `Subscriber`를 연결한다.
   - [`Subscriber`](Subscriber)를 생성하고 반환하기 전에,  무제한 수(`.unlimited`)의 value를 요청한다.
   - `AnyCancellabel` instance를 반환한다.
 */
example("sink") {
    let publihser = Just("Element")
    _ = publihser.sink(receiveCompletion: { (completion) in
        print(completion)
    }, receiveValue: { (value) in
        print(value)
    })
}
/*:
 - `assign(to:, on:)`
   - [`Publisher`](Publisher)에서 emit된 element를 객체의 속성에 할당한다.
   - `AnyCancellabel` instance를 반환한다.
 */
example("assign") {
    class SomeObject {
        var value: Int = 0 {
            didSet {
                print(self.value)
            }
        }
    }
    let objct = SomeObject()
    let publisher = (0..<10).publisher
    _ = publisher.assign(to: \.value, on: objct)
}
//: [Next](@next)
