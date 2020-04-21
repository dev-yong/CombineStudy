//: [Previous](@previous)
import Foundation
import Combine
/*:
 # Publisher
 
 - `Publisher`는 하나 이상의 **Event**를 [`Subscriber`](Subscriber)에게 전달한다.
 - [`Subscriber`](Subscriber)를 attach하고자 할 때, ❌`receive(subscriber:)`가 아닌 ✅`subscribe(_:)`를 호출해야한다.
   - `Publisher` protocol를 채택하는 객체는 `receive(subscriber:)`를 필수적으로 구현하여야 한다.
   - `subscribe(_:)`의 구현부에서 `receive(subscriber:)`를 호출한다.
 
 [Documentation](https://developer.apple.com/documentation/combine/publisher)
 */
protocol _Publisher {

    associatedtype Output
    associatedtype Failure : Error

    func receive<S>(subscriber: S)
        where S: Subscriber,
        Self.Failure == S.Failure,
        Self.Output == S.Input
}

extension _Publisher {

  func subscribe<S>(_ subscriber: S)
    where S : Subscriber,
    Self.Failure == S.Failure,
    Self.Output == S.Input {
        //...
    }
}
/*:
 ## Event
 
 - Value(i.e. Element) Event
   - zero 혹은 그 이상을 emit할 수 있다.
 - Completion Event
   - `.failure(e)` or `.finished`
   - 오로지 한번만 emit될 수 있다.
   - Completion이 emit되면, 더 이상의 event를 emit할 수 없다.
*/
example("Publisher") {
    let notificationCenter = NotificationCenter.default
    
    let publisher = notificationCenter.publisher(for: .custom, object: nil)
        .map { $0.object as? String }
    
    let subscriber = Subscribers.Sink<String?, Never>(receiveCompletion: { _ in
        print("Finished")
    }, receiveValue: {
        print($0 ?? "")
    })
    publisher.subscribe(subscriber)
    // publisher.receive(subscriber: subscriber) ❌
    
    notificationCenter.post(name: .custom, object: "Hello Publihser")
}

extension Notification.Name {
    static let custom = Notification.Name("CustomNotification")
}
//: [Next](@next)
