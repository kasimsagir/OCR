//
// CommonResponseOfListOfLogData.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct CommonResponseOfListOfLogData: Codable {

    public var code: Int
    public var data: [LogData]?
    public var error: String?

    public init(code: Int, data: [LogData]?, error: String?) {
        self.code = code
        self.data = data
        self.error = error
    }


}

