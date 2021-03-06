//
// CommonResponseOfListOfUserMedicineDAO.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct CommonResponseOfListOfUserMedicineDAO: Codable {

    public var code: Int
    public var data: [UserMedicineDAO]?
    public var error: String?

    public init(code: Int, data: [UserMedicineDAO]?, error: String?) {
        self.code = code
        self.data = data
        self.error = error
    }


}

