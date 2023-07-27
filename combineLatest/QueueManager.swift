//
//  DownloadManager.swift
//  combineLatest
//
//  Created by Amit Azulay on 27/07/2023.
//

import Combine
import Foundation

class QueueManager {
    static let shared = QueueManager()
    private init() {}
        
    private let queueOne = DispatchQueue(
        label: "queueOne",
        qos: .userInteractive,
        attributes: [],
        autoreleaseFrequency: .workItem
    )
    
    private let queueTow = DispatchQueue(
        label: "queueTow",
        qos: .userInteractive,
        attributes: [],
        autoreleaseFrequency: .workItem
    )
    
    private let queueThree = DispatchQueue(
        label: "queueThree",
        qos: .userInteractive,
        attributes: [],
        autoreleaseFrequency: .workItem
    )
    
    func startTaskOne() -> AnyPublisher<TaskSuccess, Error> {
        Future { [weak self] promise in
            self?.queueOne.async {
                print("Start process on \(self?.queueOne.label ?? "")")
                let isSuccess = 1<2
                if isSuccess {
                    promise(.success(TaskSuccess.taskOneSuccess(Date())))
                } else {
                    promise(.failure(TaskError.taskOneError(Date())))
                }
            }
        }.eraseToAnyPublisher()
    }

    func startTaskTow() -> AnyPublisher<TaskSuccess, Error> {
        Future { [weak self] promise in
            self?.queueTow.asyncAfter(deadline: .now() + 1) {
                print("Start process on \(self?.queueTow.label ?? "")")
                let isSuccess = 1<2
                if isSuccess {
                    promise(.success(TaskSuccess.taskTowSuccess(Date())))
                } else {
                    promise(.failure(TaskError.taskTowError(Date())))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func startTaskThree() -> AnyPublisher<TaskSuccess, Error> {
        Future { [weak self] promise in
            self?.queueThree.asyncAfter(deadline: .now() + 2) {
                print("Start process on \(self?.queueThree.label ?? "")")
                let isSuccess = 1<2
                if isSuccess {
                    promise(.success(TaskSuccess.taskThreeSuccess(Date())))
                } else {
                    promise(.failure(TaskError.taskThreeError(Date())))
                }
            }
        }.eraseToAnyPublisher()
    }
}

enum TaskError: Error {
    case taskOneError(Date)
    case taskTowError(Date)
    case taskThreeError(Date)
}

enum TaskSuccess {
    case taskOneSuccess(Date)
    case taskTowSuccess(Date)
    case taskThreeSuccess(Date)
}

