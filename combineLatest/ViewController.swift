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
            } receiveValue: { [weak self] taskOneResult, taskTowResult, taskThreeResult in
                self?.handleSuccess(taskOneResult: taskOneResult, taskTowResult: taskTowResult, taskThreeResult: taskThreeResult)
            }.store(in: &storeBag)
    }
    
    private func handleError(error: Error) {
        guard let error = error as? TaskError else { return }
        switch error {
        case .taskOneError(_): break
        case .taskTowError(_): break
        case .taskThreeError(_): break
        }
        print("error: \(error)")
    }
    
    private func handleSuccess(taskOneResult: TaskSuccess, taskTowResult: TaskSuccess, taskThreeResult: TaskSuccess) {
        print("queue one result: \(taskOneResult)\nqueue tow result: \(taskTowResult)\nqueue three result: \(taskThreeResult).\ncompleted\(Thread.isMainThread ? "" : "NOT") on the Main Thread")
    }
}

