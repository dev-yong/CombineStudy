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
    print("")
    
    numbers.publisher
        .collect()
        .sink { print("\($0)") }
    
    numbers.publisher
        .collect(2)
        .sink { print("\($0)") }
}
example("collection with error") {
    _ = (0...10).publisher
        .tryMap {
            guard $0 == 5 else {
                return
            }
            throw CustomError.custom(description: "Custom Error occurred")
        }
        .collect()
        .sink(receiveCompletion: { print("Completion : ", $0) },
              receiveValue: { print("Value : ", $0) })
}
/*:
 ## map
 제공된 closure를 사용하여 upstream publisher의 모든 요소를 변환한다.
 [Documentation](https://developer.apple.com/documentation/combine/publisher/3204718-map)
 */
example("map") {
    _ = (0...10).publisher
        .map { $0 * 2 }
        .sink { print("\($0)", terminator: " ") }
}
/*:
 ### Map Key Path
 `map` operator를 이용하여 KeyPath를 publish할 수 있다.
 */
example("map key path") {
    struct Position {
        let x: Double
        let y: Double
    }
    
    Just(Position(x: Double.random(in: 0...375), y: Double.random(in: 0...812)))
        .map(\.x, \.y)
        .sink { print ("Value: \($0)") }
}
/*:
 ## tryMap
 제공된 error-throwing closure를 사용하여 upstream publisher의 모든 요소를 변환한다.
 [Documentation](https://developer.apple.com/documentation/combine/publisher/3204772-trymap)
 */
example("tryMap") {
    _ = (0...10).publisher
        .tryMap {
            guard $0 == 5 else {
                return $0
            }
            throw CustomError.custom(description: "Custom Error occurred")
        }
        .sink(receiveCompletion: { print("Completion : ", $0) },
              receiveValue: { print("Value : ", $0) })
}
//: [Next](@next)
