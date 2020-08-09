//: [Previous](@previous)
import Foundation
import Combine
/*:
 # Creating your own publishers
 ## Publisher를 만드는 3가지 방법
 - [`Pulisher`](Publisher) nampespace에서 간단한 extension을 이용한다.
 - 값을 생성하는 `Subscription`으로 `Publishers` namespace의 type을 구현.
 - Upstream publisher를 transform하는 `Subscription`으로 구현

 > Custom Publisher를 Custom Subscription 없이 구현할 경우, [Subscriber](Subscriber)의 demand에 대한 대처능력을 잃을 수 있다.
 > 이는 Combine Ecosystem에서 Publisher가 illegal하게 한다.
 */
/*:
 ## Publishers as extension methods
- Custom Publisher로 인하여 signature가  복잡해 질 수 있으니, 연산자가 `AnyPublisher` 를 반환하도록 한다.
 */
extension Publisher {
  
    func unwrap<T>() -> Publishers.CompactMap<Self, T>
        where Output == Optional<T> {
            return self.compactMap { $0 }
    }
    
    func unwrap2<T>() -> AnyPublisher<T, Failure>
        where Output == Optional<T> {
            return self.compactMap { $0 }
                .eraseToAnyPublisher()
    }
    
}
example("unwrap") {
    
    let values: [Int?] = [1, 2, nil, 3, nil, 4]
    
    values.publisher
        .unwrap()
        .sink {
            print("Unwrapped value: \($0)")
        }
    values.publisher
        .unwrap2()
        .sink {
            print("Unwrapped value2: \($0)")
        }
}
/*:
 ## The subscription mechanism
 1. Subscriber가 Publihser를 **subscribe**한다.
 2. Publisher가 Subscription을 생성하고 Subscriber의 `receive(subscription:)` 을 통해 Subscriber 에게 넘긴다.
    - Subscription은 Subscriber로부터 받은 **`demand`를 받고 event를 생성**해야하는 책임이 있다.
 3. Subscriber는 Subscription의 `request(_:)`를 이용하여 Subscription에게 원하는 value의 개수를 보낸다.
 4. Subscription은 받은 작업을 시작하고 Subscriber의 `receive(_:)`를 호출하여 value를 emit한다.
 5. 값을 받으면 Subscriber는 새로운 `Subscribers.Demand`를 반환하여 total demand에 추가한다.
 6. Subscription은 보낸 값의 수가 총 요청 수에 도달할 때 까지 계속 값을 전달한다.
 */
protocol _Subscription {

    func request(_ demand: Subscribers.Demand)
}
protocol _Subscriber {

    associatedtype Input
    associatedtype Failure : Error
    
    func receive(subscription: Subscription)
    func receive(_ input: Self.Input) -> Subscribers.Demand
}
/*:
 ## Building your subscription
 Subscription의 역할
 - Subscriber로부터 초기 demand를 받아라.
 - demand에 따라 value를 생성한다.
 - Subscriber가 value를 받고 demand를 반환할 때마다, demand count에 추가해라.
 - 요청한 것 보다 더 많은 값을 생성하지 않았는가 확인하라.
 - Publihser와 Subscriber 사이의 연결 고리이다.

 */
//: [Next](@next)
