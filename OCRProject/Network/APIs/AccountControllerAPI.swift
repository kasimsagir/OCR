//
// AccountControllerAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class AccountControllerAPI {
    /**
     login
     
     - parameter loginRequestDTO: (body) loginRequestDTO 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func loginUsingPOST(loginRequestDTO: LoginRequestDTO, completion: @escaping ((_ data: CommonResponseOfUserDTO?,_ error: Error?) -> Void)) {
        loginUsingPOSTWithRequestBuilder(loginRequestDTO: loginRequestDTO).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     login
     - POST /account/login
     - API Key:
       - type: apiKey Authorization 
       - name: JWT
     - examples: [{output=none}]
     
     - parameter loginRequestDTO: (body) loginRequestDTO 

     - returns: RequestBuilder<CommonResponseOfUserDTO> 
     */
    open class func loginUsingPOSTWithRequestBuilder(loginRequestDTO: LoginRequestDTO) -> RequestBuilder<CommonResponseOfUserDTO> {
        let path = "/account/login"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: loginRequestDTO)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<CommonResponseOfUserDTO>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     register
     
     - parameter registerRequestDTO: (body) registerRequestDTO 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func registerUsingPOST(registerRequestDTO: RegisterRequestDTO, completion: @escaping ((_ data: CommonResponseOfUserDTO?,_ error: Error?) -> Void)) {
        registerUsingPOSTWithRequestBuilder(registerRequestDTO: registerRequestDTO).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     register
     - POST /account/register
     - API Key:
       - type: apiKey Authorization 
       - name: JWT
     - examples: [{output=none}]
     
     - parameter registerRequestDTO: (body) registerRequestDTO 

     - returns: RequestBuilder<CommonResponseOfUserDTO> 
     */
    open class func registerUsingPOSTWithRequestBuilder(registerRequestDTO: RegisterRequestDTO) -> RequestBuilder<CommonResponseOfUserDTO> {
        let path = "/account/register"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: registerRequestDTO)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<CommonResponseOfUserDTO>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
