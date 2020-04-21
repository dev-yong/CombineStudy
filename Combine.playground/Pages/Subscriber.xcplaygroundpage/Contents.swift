//: [Previous](@previous)
import Foundation
import Combine
/*:
 # Subscriber
 
 - Publisher로부터 입력받을 수있는 Type을 선언하는 protocol이다.
 - `Subscriber.Input`, `Subscriber.Failure`는 `Publisher.Output`, `Publisher.Failure`과 알맞아야 한다.
 
 [Documentation](https://developer.apple.com/documentation/combine/subscriber)
*/
protocol _Subscriber: CustomCombineIdentifierConvertible {

    associatedtype Input
    associatedtype Failure: Error

    /// Tells the subscriber that it has successfully subscribed to the publisher and may request items.
    ///
    /// Use the received `Subscription` to request items from the publisher.
    /// - Parameter subscription: A subscription that represents the connection between publisher and subscriber.
    func receive(subscription: Subscription)

    /// Tells the subscriber that the publisher has produced an element.
    ///
    /// - Parameter input: The published element.
    /// - Returns: A `Demand` instance indicating how many more elements the subcriber expects to receive.
    func receive(_ input: Self.Input) -> Subscribers.Demand

    /// Tells the subscriber that the publisher has completed publishing, either normally or with an error.
    ///
    /// - Parameter completion: A `Completion` case indicating whether publishing completed normally or with an error.
    func receive(completion: Subscribers.Completion<Self.Failure>)
}
/*:
 ## Operator로 제공되어지는 Subscriber
 - `sink(receiveCompletion:, receiveValue:)`
   - Closuer 기반 동작으로 subscriber를 연결한다.
   - Subscriber를 생성하고 반환하기 전에,  무제한 수(`.unlimited`)의 value를 요청한다.
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
   - Publisher에서 emit된 element를 객체의 속성에 할당합니다.
   - `AnyCancellabel`instance를 반환한다.
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
