//: [Previous](@previous)
import Foundation
import Combine
/*:
 # Future
 
 - [`Future`](Future)는 [`Publisher`](Publisher)를 채택하고 있으며, 비동기적으로 단일 result를 생산한 다음 complete하는데 사용할 수 있다.
 
 [Documentation](https://developer.apple.com/documentation/combine/future)
 */
example("Future") {
    
    func increment(_ value: Int,
                   afterDelay delay: TimeInterval) -> Future<Int, Never> {
        return Future<Int, Never> { (promise) in
            DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                promise(.success(value + 1))
            }
        }
    }
    
    let future = increment(1, afterDelay: 5)
    print(Date(), "Start")
    
    future.sink(receiveValue: {
        print(Date(), $0)
    }).store(in: &cancellableBag)

}
//: [Next](@next)
