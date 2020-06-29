//: [Previous](@previous)
import Foundation
import Combine
/*:
 # Sequence Operators
 - **Greedy** : `.finished` completion event를 보낼 때 까지 publisher가 기다린다.
 - **Lazy** : Publihser가 completion event를 보낼 때 까지 기다리지 않고, 조건을 충족하면 subscription을 취소한다.
 ## Finding Value
 ### min
 - Publisher에 의하여 emit된 value들 중 최소값을 찾는다.
 - Greedy하다.
 - Value가 `Comparable`을 채택하고 있기 때문에, 최소값을 찾을 수 있다.
 */
example("min") {
    let publisher = PassthroughSubject<Int, Never>()
    
    publisher
        .min()
        .sink(receiveValue: { print("Minimum Value :", $0) })
        .store(in: &cancellableBag)
    
    publisher.send(4)
    publisher.send(3)
    publisher.send(5)
    publisher.send(1)
    publisher.send(2)
    publisher.send(completion: .finished)
}
/*:
 - Value가 `Comparable`을 채택하고 있지 않을 경우, `min(by: )`를 이용한다.
 */
example("min(by: )") {
    
    struct S {
        let value: Int
    }
    [S(value: 0), S(value: 1), S(value: 2)].publisher
        .min(by: { $0.value < $1.value })
        .sink(receiveValue: { print("Minimum Value :", $0) })
        .store(in: &cancellableBag)
}
/*:
  ### max
  - Publisher에 의하여 emit된 value들 중 최대값을 찾는다.
  - Greedy하다.
  - Value가 `Comparable`을 채택하고 있기 때문에, 최대값을 찾을 수 있다.
  */
 example("max") {
     let publisher = PassthroughSubject<Int, Never>()
     
     publisher
        .max()
         .sink(receiveValue: { print("Maximum Value :", $0) })
         .store(in: &cancellableBag)
     
     publisher.send(4)
     publisher.send(3)
     publisher.send(5)
     publisher.send(1)
     publisher.send(2)
     publisher.send(completion: .finished)
 }
 /*:
  - Value가 `Comparable`을 채택하고 있지 않을 경우, `max(by: )`를 이용한다.
  */
 example("max(by: )") {
     
     struct S {
         let value: Int
     }
     [S(value: 0), S(value: 1), S(value: 2)].publisher
         .max(by: { $0.value < $1.value })
         .sink(receiveValue: { print("Maximum Value :", $0) })
         .store(in: &cancellableBag)
 }
/*:
 ### first
 - 첫 번째 값을 emit한 이후, 바로 complete을 보낸다.
 - Lazy 하다.
 */
example("first") {
    
    [4, 2, 1, 3].publisher
        .first()
        .sink(receiveValue: { print("First Value : ", $0) })
        .store(in: &cancellableBag)
}
/*:
 - `first(where: )`를 이용하여 좀더 세밀한 제어를 할 수 있다.
 */
example("first(where: )") {
    
    struct S {
        let value: Int
    }
    [S(value: 0), S(value: 1), S(value: 2)].publisher
        .first(where: { $0.value % 2 == 0 })
        .sink(receiveValue: { print("First Value :", $0) })
        .store(in: &cancellableBag)
}
/*:
 ### last
 - 마지막 값을 emit한다.
 - Greedy 하다.
 */
example("last") {
    
    [4, 2, 1, 3].publisher
        .last()
        .sink(receiveValue: { print("First Value : ", $0) })
        .store(in: &cancellableBag)
}
/*:
- `last(where: )`를 이용하여 좀더 세밀한 제어를 할 수 있다.
*/
example("last(where: )") {
    
    struct S {
        let value: Int
    }
    [S(value: 0), S(value: 1), S(value: 2)].publisher
        .last(where: { $0.value % 2 == 0 })
        .sink(receiveValue: { print("First Value :", $0) })
        .store(in: &cancellableBag)
}
/*:
 ### output(at: )
 - 특정한 index에 emit되어진 value만을 emit한다.
 - 그렇기 때문에, Upstream Publisher에서 값이 emit되어질 때마다 `.max(1)`을 요구(`Demand`)한다.
 */
example("output(at: )") {
    
    [4, 2, 1, 3].publisher
        .output(at: 2)
        .sink(receiveValue: { print("Value : ", $0) })
        .store(in: &cancellableBag)
}
/*:
 ### output(in: )
 -  특정한 index들에 emit되어진 value만을 emit한다.
 - Value를 sequence가 아닌 별개로 emit한다.
 */
example("output(in: )") {
    
    [4, 2, 1, 3].publisher
        .output(in: 1...3)
        .sink(receiveValue: { print("Value : ", $0) })
        .store(in: &cancellableBag)
}
/*:
 ## Querying the publisher
 ### count
 - Upstream publihser에서 emit된 value들의 숫자를 emit한다.
 - Greedy 하다.
 */
example("count") {
    let publisher = PassthroughSubject<Int, Never>()
    
    publisher
        .count()
        .sink(receiveValue: { print("Count Value :", $0) })
        .store(in: &cancellableBag)
    
    publisher.send(4)
    publisher.send(3)
    publisher.send(5)
    publisher.send(1)
    publisher.send(2)
    publisher.send(completion: .finished)
}
/*:
 ### contain
 - Upstream publihser에서 emit된 value들 중 특정 value와 동일할 경우 true를, 그렇지 않을 경우 false를 emit한다.
 - true일 경우 lazy, false일 경우 greedy하다.
 */
example("contains") {
    let publisher = PassthroughSubject<Int, Never>()
    
    publisher
        .print()
        .contains(5)
        .sink(receiveValue: { print("Value :", $0) })
        .store(in: &cancellableBag)
    
    publisher.send(4)
    publisher.send(3)
    publisher.send(5)
    publisher.send(1)
    publisher.send(2)
//    publisher.send(completion: .finished)
}
/*:
 ### allSatisfy
 - Upstream publisher에서 emit된 value들이 모두 predicate closure를 충족할 경우에 대하여 bool 값을 emit한다.
 - false일 경우 lazy, true일 경우 Greedy 하다.
 */
example("allSatisfy") {
    let publisher = PassthroughSubject<Int, Never>()
    
    publisher
    .print()
        .allSatisfy { $0 <= 5 }
        .sink(receiveValue: { print("Value :", $0) })
        .store(in: &cancellableBag)
    
    publisher.send(4)
    publisher.send(6)
    publisher.send(5)
    publisher.send(1)
    publisher.send(2)
//    publisher.send(6)
//    publisher.send(completion: .finished)
}
/*:
 ### reduce
 - Upstream Publisher의 emission을 기준으로 새로운 값을 반복적으로 축적할 수 있다.
 - Greedy 하다.
 */
example("reduce") {
    let publisher = PassthroughSubject<Int, Never>()
    
    publisher
        .reduce(0, +)
        .sink(receiveValue: { print("Value :", $0) })
        .store(in: &cancellableBag)
    
    publisher.send(4)
    publisher.send(3)
    publisher.send(5)
    publisher.send(1)
    publisher.send(2)
    publisher.send(completion: .finished)
}
//: [Next](@next)
