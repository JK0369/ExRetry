//
//  ViewController.swift
//  ExRetry
//
//  Created by Jake.K on 2022/06/13.
//

import Foundation
import UIKit
import RxSwift

class ViewController: UIViewController {
  
  let disposeBag = DisposeBag()
  
  let someObservable = Observable<String>.create { observer in
    observer.onNext("1")
    observer.onNext("2")
    observer.onNext("3")
    let myError = NSError(domain: "MyError", code: 0)
    observer.onError(myError)
    return Disposables.create()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
//    self.someObservable
//      .subscribe { print($0) }
//      .disposed(by: self.disposeBag)
    /*
     next(1)
     next(2)
     next(3)
     error(Error Domain=MyError Code=0 "(null)")
     */
    
//    self.someObservable
//      .retry(2) // 에러가 발생한 경우 한 번 retry
//      .subscribe { print($0) }
//      .disposed(by: self.disposeBag)
    /*
     next(1)
     next(2)
     next(3)
     next(1)
     next(2)
     next(3)
     error(Error Domain=MyError Code=0 "(null)")
     */
    
//    let scheduler = MainScheduler.asyncInstance
//    self.someObservable
//      .observe(on: scheduler)
//      .retry(
//        when: { errorObservable in
//          errorObservable.enumerated()
//            .flatMap { count, error -> Observable<Void> in
//              guard count < 3 else { throw error }
//              return Observable<Void>.just(())
//                .delay(.seconds(1), scheduler: scheduler)
//            }
//        }
//      )
//      .subscribe(
//        onNext: { print($0) },
//        onError: { print($0) },
//        onCompleted: { print("completed") },
//        onDisposed: { print("disposed") }
//      )
//      .disposed(by: self.disposeBag)
    
    /*
     1
     2
     3
     1
     2
     3
     1
     2
     3
     1
     2
     3
     Error Domain=MyError Code=0 "(null)"
     disposed
     */
    
    // Exponential
    let scheduler = MainScheduler.asyncInstance
    self.someObservable
      .observe(on: scheduler)
      .retry(
        when: { errorObservable in
          errorObservable.enumerated()
            .flatMap { count, error -> Observable<Void> in
              guard count < 3 else { throw error }
              let retryDyaly = Int(pow(Double(count), 2))
              return Observable<Void>.just(())
                .delay(.seconds(retryDyaly), scheduler: scheduler)
            }
        }
      )
      .subscribe(
        onNext: { print($0) },
        onError: { print($0) },
        onCompleted: { print("completed") },
        onDisposed: { print("disposed") }
      )
      .disposed(by: self.disposeBag)
  }
}

extension ObservableType {
  
}
