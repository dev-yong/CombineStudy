//: [Previous](@previous)
import Foundation
import Combine
import UIKit
/*:
 # Combining Operators
 ## Prepending
 본래 publisher의 값보다 먼저 emit되는 값을 추가 할 수 있다.
 [Documentation](https://developer.apple.com/documentation/combine/publisher/3204739-prepend)
 */
example("prepend") {
    [3, 4, 5].publisher
        .prepend(2)
        .prepend(0, 1)
        .sink(receiveValue: { print("Value : \($0)") })
        .store(in: &cancellableBag)
}
/*:
 [Documentation](https://developer.apple.com/documentation/combine/publisher/3204740-prepend)
 */
example("prepend sequence") {
    (3...10).publisher
        .prepend([0, 1, 2])
        .sink(receiveValue: { print("Value : \($0)") })
        .store(in: &cancellableBag)
}
/*:
 Prepend되는 publisher가  complete이 되어야 prepending이 끝남을 알 수 있고
 계속해서 본래의 publisher를 시작할 수 있다.
 [Documentation](https://developer.apple.com/documentation/combine/publisher/3204741-prepend)
 */
example("prepend publisher") {
    let suffix = (5...10).publisher
    let prefix = CurrentValueSubject<Int, Never>(1)
    suffix
        .prepend(prefix)
        .sink(receiveValue: { print("Value : \($0)") })
        .store(in: &cancellableBag)
    prefix.send(2)
    prefix.send(3)
    prefix.send(4)
    prefix.send(completion: .finished)
}
/*:
 # Appending
 Prepending과는 반대로, 본래 publisher의 값들 이후에 emit되는 값을 추가할 수 있다.
 [Documentation](https://developer.apple.com/documentation/combine/publisher/3204683-append)
 */
example("append") {
    [0, 1, 2].publisher
        .append(3)
        .append(4, 5)
        .sink(receiveValue: { print("Value : \($0)") })
        .store(in: &cancellableBag)
}
/*:
 [Documentation](https://developer.apple.com/documentation/combine/publisher/3204684-append)
 */
example("append sequence") {
    (0...5).publisher
        .append([6, 7, 8, 9])
        .sink(receiveValue: { print("Value : \($0)") })
        .store(in: &cancellableBag)
}
/*:
 본래의 publisher가  complete이 되어야 계속해서 append되는 publisher를 시작할 수 있다.
 [Documentation](https://developer.apple.com/documentation/combine/publisher/3204685-append)
 */
example("append publisher") {
    let prefix = CurrentValueSubject<Int, Never>(0)
    let suffix = CurrentValueSubject<Int, Never>(3)
    prefix
        .append(suffix)
        .sink(receiveValue: { print("Value : \($0)") })
        .store(in: &cancellableBag)
    
    prefix.send(1)
    prefix.send(2)
    prefix.send(completion: .finished)
    suffix.send(4)
    suffix.send(5)
}
/*:
 # Advanced combining
 ## switchToLatest
 여러개의 Upstream publisher들을 flat하게 하여, 단일 event stream에서 온 것 같이 만든다.
 */
example("switchToLatest") {
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<Int, Never>()
    
    let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
    publishers
        .switchToLatest()
        .sink(receiveCompletion: { print("Complete :", $0) },
              receiveValue: { print("Value :", $0) })
        .store(in: &cancellableBag)
    
    publishers.send(publisher1)
    publisher1.send(1)
    publisher1.send(2)
    
    // publisher2를 보내었기 때문에, publisher1에 대한 subscription은 cancel이 되었다.
    publishers.send(publisher2)
    // 따라서, publisher1에 value를 보내어도 publishers에서는 받지 않는다.
    publisher1.send(3)
    publisher2.send(4)
    publisher2.send(5)
}

example("switchToLatest URL") {
    let url = URL(string: "https://source.unsplash.com/random")!
    let subject = PassthroughSubject<Void, Never>()
    subject
        .map { _ -> AnyPublisher<UIImage?, Never> in
            URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                .eraseToAnyPublisher()
        }
        // 이전의 publisher에 대한 subscription은 cancel하기 때문에
        // 오로지 하나의 publisher만이 value를 emit할 것을 보장한다.
        .switchToLatest()
        .sink(
            receiveCompletion: { print("Complete: \($0)") },
            receiveValue: { print("Value: \(String(describing: $0))")}
        )
        .store(in: &cancellableBag)
    
    subject.send()
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        subject.send()
    }
}
/*:
 # merge
 
 */
/*:
 # combineLatest

*/
/*:
 # zip

*/
//: [Next](@next)
