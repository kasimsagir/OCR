//
// CommonResponseOfboolean.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct CommonResponseOfboolean: Codable {

    public var code: Int
    public var data: Bool?
    public var error: String?

    public init(code: Int, data: Bool?, error: String?) {
        self.code = code
        self.data = data
        self.error = error
    }


}

