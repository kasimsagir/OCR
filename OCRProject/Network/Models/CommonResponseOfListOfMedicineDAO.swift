//
// CommonResponseOfListOfMedicineDAO.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct CommonResponseOfListOfMedicineDAO: Codable {

    public var code: Int
    public var data: [MedicineDAO]?
    public var error: String?

    public init(code: Int, data: [MedicineDAO]?, error: String?) {
        self.code = code
        self.data = data
        self.error = error
    }


}

