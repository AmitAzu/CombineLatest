//
//  ViewController.swift
//  combineLatest
//
//  Created by Amit Azulay on 27/07/2023.
//

import Combine
import UIKit

class ViewController: UIViewController {
    
    private var storeBag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let taskOnePublisher = QueueManager.shared.startTaskOne()
        let taskTowPublisher = QueueManager.shared.startTaskTow()
        let taskThreePublisher = QueueManager.shared.startTaskThree()
        
        Publishers
            .CombineLatest3(
                taskOnePublisher,
                taskTowPublisher,
                taskThreePublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self?.handleError(error: error)
                }
            } receiveValue: { [weak self] queueOneResult, queueTowResult, queueThreeResult in
                self?.handleSuccess(queueOneResult: queueOneResult, queueTowResult: queueTowResult, queueThreeResult: queueThreeResult)
            }.store(in: &storeBag)
    }
    
    func handleError(error: Error) {
        guard let error = error as? QueueError else { return }
        switch error {
        case .queueOneError(_): break
        case .queueTowError(_): break
        case .queueThreeError(_): break
        }
        print("error: \(error)")
    }
    
    func handleSuccess(queueOneResult: QueueSuccess, queueTowResult: QueueSuccess, queueThreeResult: QueueSuccess) {
        print("queue one result: \(queueOneResult)\nqueue tow result: \(queueTowResult)\nqueue three result: \(queueThreeResult)")
        if Thread.isMainThread {
            print("completed on the Main Thread")
        } else {
            print("completed NOT on the Main Thread")
        }
    }
}

