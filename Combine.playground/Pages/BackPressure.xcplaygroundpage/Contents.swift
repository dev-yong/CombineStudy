//: [Previous](@previous)
import Foundation
import Combine
/*:
 # Backpressure
 - Publisher가 원하는 flow of value에 반대하는 저항
 - Push design이 아닌, **Pull design**이다. (???)
    - Subscriber가 Publisher에게 몇 개의 value를  emit하여 달라고 요청하고 얼마나 받을지 명시한다.
 - Subscriber가 새로운 value를 받을 때마다, demand가 업데이트 된다.
    - 이를 통하여 새로운 value를 받는 것을 막을(closing the tap) 수도 있고, 준비가 되었을 때 받을(opening it) 수도 있다.
 ## Design
 - Publisher가 감당할 수 있는 것보다 많은 value를 보내는 것을 막기위하여 Demand를 관리함으로써 흐름을 통제(**Control the flow**)하라.
 - Value들을 감당할 수 있을 때까지 value를  보관(**Buffer**)해라.
 - 당장 감당할 수 없는 value를 버려라(**Drop**).
 */

//: [Next](@next)
