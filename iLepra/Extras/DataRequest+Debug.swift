//
//  DataRequest+Debug.swift
//  iLepra
//
//  Created by Maxim Potapov on 01.04.2023.
//

import Alamofire
import OSLog

extension DataRequest {
    func debugPrint(with logger: Logger) -> Self {
        responseString(encoding: .utf8) { response in
            let path = response.request?.url?.path() ?? "n/a"
            switch response.result {
            case let .success(string):
                let output = NSMutableString(string: .init(string.prefix(5000)))
                CFStringTransform(output, nil, "Any-Hex/Java" as NSString, true)
                logger.log(level: .debug, "🛬 \(path)\n\(output)")
            case let .failure(error):
                logger.log(level: .debug, "💩 \(path)\n\(error)")
            }
        }
    }
}
