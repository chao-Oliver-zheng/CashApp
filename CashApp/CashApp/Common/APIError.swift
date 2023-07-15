//
//  APIError.swift
//  CashApp
//
//  Created by Oliver Zheng on 7/12/23.
//

import Foundation

enum APIError: Error {
    case invalidUrl
    case invalidResponse
    case emptyData
    case serviceUnavailable
    case decodingError
    
    var description: String {
        switch self {
        case .invalidUrl:
            return "Invalid Url"
        case .invalidResponse:
            return "Invalid Response:"
        case .emptyData:
            return "Empty Data"
        case .serviceUnavailable:
            return "Service Unavailable"
        case .decodingError:
            return "Decoding Error"
        }
    }
}
