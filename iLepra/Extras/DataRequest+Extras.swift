//
//  DataRequest+Extras.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import Alamofire

extension DataRequest {
    func debugPrint() -> Self {
        responseData { response in
            switch response.result {
            case let .success(data):
                Swift.debugPrint(String(data: data, encoding: .utf8) ?? "n/a")
            case let .failure(error):
                Swift.debugPrint(String(describing: error))
            }
        }
    }
}
