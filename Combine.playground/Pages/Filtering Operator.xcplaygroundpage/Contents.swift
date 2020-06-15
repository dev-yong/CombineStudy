//: [Previous](@previous)
import Foundation
import Combine
/*:
 # Filtering Operator
**보완 필요!**
 
 ## filter
 제공된 closure와 일치하는 모든 element를 republish한다.
 */
example("filter") {
    (1...10).publisher
        .filter { $0 % 2 == 0 }
        .sink(receiveValue: { print("Value : \($0)") })
        .store(in: &cancellableBag)
}
/*:
## removeDuplicates
 제공된 clousre에서 평가한대로 이전 element와 일치하지 않는 element 만 publish한다.
*/
example("removeDuplicate") {
    
    "안녕하세요 안녕하세요 반갑습니다 잘부탁드립니다 안녕하세요"
        .components(separatedBy: " ")
        .publisher
        .removeDuplicates()
        .sink(receiveValue: { print("Value : \($0)") })
        .store(in: &cancellableBag)
}
/*:
## compactMap
 받은 각 element와 함께 closure를 호출하고 값이 있는 optional을 publish한다.
*/
example("compactMap") {
    (1...10).publisher
        .compactMap { value -> Int? in
            guard value % 2 == 0 else { return nil }
            return value
        }
        .sink(receiveValue: { print("Value : \($0)") })
        .store(in: &cancellableBag)
}
/*:
## ignoreOutput
 모든 Upstream의 element를 무시하지만 completion(finisihed 혹은 failed)는 통과한다.
*/
example("ignoreOutput") {
    (1...10).publisher
        .ignoreOutput()
        .sink(receiveCompletion: { print("Completion : \($0)") },
              receiveValue: { print("Value : \($0)") })
        .store(in: &cancellableBag)
}
/*:
## first
 Upstream의 첫 번째 element를 publish한 다음 finish한다.
*/
example("first") {
    (1...10).publisher
        .first { $0 % 2 == 0 }
        .sink(receiveCompletion: { print("Completion : \($0)") },
              receiveValue: { print("Value : \($0)") })
        .store(in: &cancellableBag)
}
/*:
## last
 Upstream의 마지막 element를 publish한 다음 finish한다.
*/
example("last") {
    (1...10).publisher
        .last { $0 % 2 == 0 }
        .sink(receiveCompletion: { print("Completion : \($0)") },
              receiveValue: { print("Value : \($0)") })
        .store(in: &cancellableBag)
}
/*:
## drop
 나머지 모든 element를 republish하기 전에, 주어진 closure에 대하여 false를 return때 까지 Upstream publihser로부터 element를 생략한다.
*/
example("drop") {
  
    (1...10).publisher
        .drop(while: { $0 % 5 != 0 })
        .sink(receiveCompletion: { print("Completion : \($0)") },
              receiveValue: { print("Value : \($0)") })
        .store(in: &cancellableBag)
}
/*:
## prefix
 
 predicate closure가 publish가 지속되어야 함을 나타내는 동안 element들을 republish한다.
*/
example("prefix") {
  
    (1...10).publisher
        .prefix { $0 < 5 }
        .sink(receiveCompletion: { print("Completion : \($0)") },
              receiveValue: { print("Value : \($0)") })
        .store(in: &cancellableBag)
}
//: [Next](@next)
