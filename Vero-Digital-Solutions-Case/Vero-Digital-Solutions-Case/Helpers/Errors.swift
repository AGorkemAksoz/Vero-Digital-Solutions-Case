//
//  Errors.swift
//  Vero-Digital-Solutions-Case
//
//  Created by Ali Görkem Aksöz on 23.03.2023.
//

import Foundation

enum DataPersistenceError: String, Error {
    case failedToFetching = "There is a error while a fetching data"
}

enum NetworkErrors: String, Error {
    case invalidURL = "Invalid URL"
    case invalidData = "Invalid Data"
    case generalError = "An error happend"
}
