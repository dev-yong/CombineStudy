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
 # Publishers as extension methods
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
//: [Next](@next)
