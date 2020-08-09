//: [Previous](@previous)
import Combine
import Foundation
/*:
 # Scheduler
 - `subscribe(on:)` : 특정한 sheduler에서 subscription을 생성한다. (작업을 수행한다.)
 - `receive(on:)` : 특정한 scheduler에서 value를 수신함을 보장한다.
 */
/*:
 ## Publisher를 subscribe 할 때,
 1. `Publisher`는 `Subscriber`를 받고 `Subscription`을 생성한다.
 2. `Subscriber`는 `Subscription`을 받고 `Publisher`에게 value를 요청한다.
 3. `Publisher`는 작업을 시작한다.
 4. `Publisher`가 value를 방출한다.
 5. Operator는 emit된 value를 변환한다.
 6. `Subscriber`는 변환된 value를 받는다.
 
 1 ~ 3단계는 current thrad에서 발생한다.
 `subscribe(on:)`을 이용하면, 1 ~ 3단계가 특정한 scheduler에서 동작한다.
 `receive(on:)`을 이용하면, 5 ~ 6단계가 특정한 scheduler에서 동작한다.
 */
/*:
 ## `Scheduler`
 - `Scheduler`를 사용하면 가능한 빨리 혹은 미래에 실행되어야할 코드를 예약할 수 있다.
 - `Scheduler`의 구현체는 `ScedulerTimeType`을 정의한다.
 */
/*:
 ## `ImmediateScheduler`
 - Synchronous 동작을 수행하기 위한 scheduler
 - 현재 실행 스레드에서 코드를 즉시 실행하는 scheduler이다.
 - `SchedulerOptions`가 Never이기 때문에 이 를 사용하는 method parameter에 값을 전달해서는 안된다.
 - `SchedulerTimeType`의 initializer가 제공되지 않기 때문에 `schedeule(after:) 를 사용할 수 없다.
 */
/*:
 ## `RunLoop`
 - Thread 레벨 에서 input souerce를 관리하는 방법
 - `ScedulerTimeType`의 value는 `Date`이다.
 - `SchedulerOptions` 를 사용하는 method call에 적합한 option을 제공하지 않는다.
 - `RunLoop`의 사용은 필요한 경우 제어하는 Foundation에서 가능한 runloop로 제한 되어야한다.
 -  `RunLoop`는 호출을 한 당시의 thread와 연관된다.
 - `DispatchQueue`에서 코드를 실행하면서 `RunLoop.current`를 사용하는 것을 피해야한다.
 - `DispatchQueue`가 일시적일 수 있기 때문에, `RunLoop`를 사용하는 것은 거의 불가능하다.
 */
/*:
 ## `DispatchQueue`
 - 시스템에서 관리하는 DispatchQueue에 작업을 제출하여 멀티 코어 하드웨어에서 concurrent하세 코드를 실행할 수 있다.
 - Serial 혹은 concurrent 할 수 있다.
 - Queue에서 실행되는 코드의 current thread에 대해 절대 가정해서는 안된다.
    - DispatchQueue가 스레드를 관리하는 방식 때문에 `RunLoop.current`를 사용하여 작업을 예약해서는 안된다.
 - 모든  DispatchQueue는 동일한 thread pool을 공유한다.
 - **Scheduler를 지원하는 스레드가 매번 동일하다고 가정해서는 안된다.**
 
 Q. Serial Dispatch Queue will use only one and same thread?
 A.  No. Only one thread. "One thread only" does not mean "same thread always".
 */
/*:
 ## `OperationQueue`
 */
//: [Next](@next)
