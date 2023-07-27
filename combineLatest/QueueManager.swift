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
        
    let queueOne = DispatchQueue(
        label: "queueOne",
        qos: .userInteractive,
        attributes: [],
        autoreleaseFrequency: .workItem
    )
    
    let queueTow = DispatchQueue(
        label: "queueTow",
        qos: .userInteractive,
        attributes: [],
        autoreleaseFrequency: .workItem
    )
    
    let queueThree = DispatchQueue(
        label: "queueThree",
        qos: .userInteractive,
        attributes: [],
        autoreleaseFrequency: .workItem
    )
    
    func startTaskOne() -> AnyPublisher<QueueSuccess, Error> {
        Future { [weak self] promise in
            self?.queueOne.async {
                print("Start process on \(self?.queueOne.label ?? "")")
                let isSuccess = 1<2
                if isSuccess {
                    promise(.success(QueueSuccess.queueOneSuccess(Date())))
                } else {
                    promise(.failure(QueueError.queueOneError(Date())))
                }
            }
        }.eraseToAnyPublisher()
    }

    func startTaskTow() -> AnyPublisher<QueueSuccess, Error> {
        Future { [weak self] promise in
            self?.queueTow.asyncAfter(deadline: .now() + 1) {
                print("Start process on \(self?.queueTow.label ?? "")")
                let isSuccess = 1<2
                if isSuccess {
                    promise(.success(QueueSuccess.queueTowSuccess(Date())))
                } else {
                    promise(.failure(QueueError.queueTowError(Date())))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func startTaskThree() -> AnyPublisher<QueueSuccess, Error> {
        Future { [weak self] promise in
            self?.queueThree.asyncAfter(deadline: .now() + 2) {
                print("Start process on \(self?.queueThree.label ?? "")")
                let isSuccess = 1<2
                if isSuccess {
                    promise(.success(QueueSuccess.queueThreeSuccess(Date())))
                } else {
                    promise(.failure(QueueError.queueThreeError(Date())))
                }
            }
        }.eraseToAnyPublisher()
    }
}

enum QueueError: Error {
    case queueOneError(Date)
    case queueTowError(Date)
    case queueThreeError(Date)
}

enum QueueSuccess {
    case queueOneSuccess(Date)
    case queueTowSuccess(Date)
    case queueThreeSuccess(Date)
}

