//: [Previous](@previous)
import Foundation
import Combine
/*:
 # Transforming Operator
 
 - **Operator** : [`Publisher`](Publisher)로부터 제공된 값에 대하여 작업을 수행하는 method
    - Operator는 실질적으로 publihser를 반환한다.
    - 반환되는 publisher는 upstream value를 받아, 데이터를 조작, downstream으로 보낸다.
 
 ## collect
 - 받은 모든 element를 모으고, upstream publisher가 종료될 때 collection의 단일 배열로 방출한다.
 - 만일 upstream publisher가 error와 함께 실패할 경우, publisher는 결과물이 아닌 error를 downstream에게 전달한다.
 
 [Documentation](https://developer.apple.com/documentation/combine/publisher/3204692-collect)
 */
example("collect") {
    let numbers = (0...10)
    numbers.publisher
        .sink { print("\($0)", terminator: " ") }
        .store(in: &cancellableBag)
    print("")
    
    numbers.publisher
        .collect()
        .sink { print("\($0)") }
        .store(in: &cancellableBag)
    
    numbers.publisher
        .collect(2)
        .sink { print("\($0)") }
        .store(in: &cancellableBag)
}

example("collection with error") {
    (0...10).publisher
        .tryMap {
            guard $0 == 5 else {
                return
            }
            throw CustomError.custom(description: "Custom Error occurred")
        }
        .collect()
        .sink(receiveCompletion: { print("Completion : ", $0) },
              receiveValue: { print("Value : ", $0) })
        .store(in: &cancellableBag)
}
/*:
 ## map
 제공된 closure를 사용하여 upstream publisher의 모든 요소를 변환한다.
 [Documentation](https://developer.apple.com/documentation/combine/publisher/3204718-map)
 */
example("map") {
    (0...10).publisher
        .map { $0 * 2 }
        .sink { print("\($0)", terminator: " ") }
        .store(in: &cancellableBag)
}
/*:
 ## map (KeyPath)
 `map` operator를 이용하여 KeyPath를 publish할 수 있다.
 [Documentation](https://developer.apple.com/documentation/combine/publisher/3343976-map)
 */
example("map key path") {
    struct Position {
        let x: Double
        let y: Double
    }
    
    Just(Position(x: Double.random(in: 0...375), y: Double.random(in: 0...812)))
        .map(\.x, \.y)
        .sink { print ("Value: \($0)") }
        .store(in: &cancellableBag)
}
/*:
 ## tryMap
 제공된 error-throwing closure를 사용하여 upstream publisher의 모든 요소를 변환한다.
 [Documentation](https://developer.apple.com/documentation/combine/publisher/3204772-trymap)
 */
example("tryMap") {
    (0...10).publisher
        .tryMap {
            guard $0 == 5 else {
                return $0
            }
            throw CustomError.custom(description: "Custom Error occurred")
        }
        .sink(receiveCompletion: { print("Completion : ", $0) },
              receiveValue: { print("Value : ", $0) })
        .store(in: &cancellableBag)
}
/*:
 ## flatMap
 Upstream publisher의 모든 element를 `maxPublisher`까지 새로운 publisher로 변환한다.
 [Documentation](https://developer.apple.com/documentation/combine/publisher/3204712-flatmap)
 */
example("flatMap") {
    struct Message {
        let content: CurrentValueSubject<String, Never>
    }
    
    let messageSubject = PassthroughSubject<Message, Never>()
    
    messageSubject.flatMap { message -> CurrentValueSubject<String, Never> in
        return message.content
    }.sink(receiveCompletion: { print("Completion : ", $0) },
           receiveValue: { print("Value : ", $0) })
        .store(in: &cancellableBag)
    
    messageSubject.flatMap(maxPublishers: .max(1)) { message -> CurrentValueSubject<String, Never> in
        return message.content
    }.sink(receiveCompletion: { print("Completion2 : ", $0) },
           receiveValue: { print("Value2 : ", $0) })
        .store(in: &cancellableBag)
    
    let message1 = Message(content: CurrentValueSubject<String, Never>("Hello"))
    let message2 = Message(content: CurrentValueSubject<String, Never>("World"))
    messageSubject.send(message1)
    messageSubject.send(message2)
    message1.content.send("안녕")
    message2.content.send("세상")
}
/*:
 ## replaceNil
 Upstream의 element 중 nil element를 제공된 element로 바꾼다.
 [Documentation](https://developer.apple.com/documentation/combine/publisher/3204749-replacenil)
 */
example("replaceNIl") {
    ["0", "1", "2", "Not Int"].publisher
        .map { Int($0) }
        .replaceNil(with: -1)
        .sink { print(String(describing: $0), terminator: " ") }
        .store(in: &cancellableBag)
}
/*:
 ## replaceEmpty
 Upstream이 빈 stream일 경우 제공된 element로 바꾼다.
 [Documentation](https://developer.apple.com/documentation/combine/publisher/3204747-replaceempty)
 */
example("replaceEmpty") {
    [].publisher
        .replaceEmpty(with: -1)
        .sink { print("\($0)", terminator: " ") }
        .store(in: &cancellableBag)
    print("")
    (0...10).publisher
        .replaceEmpty(with:-1)
        .sink { print("\($0)", terminator: " ") }
        .store(in: &cancellableBag)
}
/*:
 ## scan
 Closure에서 반환한 마지막 값과 함께 현재 element를 closure에 제공하여 upstream publisher의 element를 변환한다.
 */
example("scan") {
    (1...5).publisher
        .scan(0) {
            print($0, $1)
            return $0 + $1
        }
        .sink { print ("Value : \($0)") }
        .store(in: &cancellableBag)
}
//: [Next](@next)
