//: [Previous](@previous)
import Foundation
import Combine
/*:
 # Recource Management
 ## share
 - `share`는 목적은 value가 아닌 reference로 publihser를 확보하는 것이다.
 - Publihser는 대개 struct이다.
 
 */
let subject = PassthroughSubject<Data, URLError>() // 2

// 2
let multicasted = URLSession.shared
  .dataTaskPublisher(for: URL(string: "https://www.raywenderlich.com")!)
  .map(\.data)
  .print("shared")
  .multicast(subject: subject)

// 3
let subscription1 = multicasted
  .sink(
    receiveCompletion: { _ in },
    receiveValue: { print("subscription1 received: '\($0)'") }
  )

let subscription2 = multicasted
  .sink(
    receiveCompletion: { _ in },
    receiveValue: { print("subscription2 received: '\($0)'") }
  )

// 4
multicasted.connect()

// 5
subject.send(Data())
//: [Next](@next)
