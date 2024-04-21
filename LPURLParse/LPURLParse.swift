//
//  LPURLParse.swift
//  LPURLParse
//
//  Created by lipeng on 2017/6/15.
//  Copyright © 2017年 lipeng. All rights reserved.
//

import Foundation

extension String {
    // 从 URLString 中截取参数
    var urlParameters: [AnyHashable: Any]? {
        
        // 解析 url
        guard let urlComponents = URLComponents(string: self), let queryItems = urlComponents.queryItems else {
            return nil
        }
        
        var parameters: [AnyHashable: Any] = [:]
        
        // 遍历 queryItems 获取每一项参数的键值对
        queryItems.forEach { (item) in
            
            /// 判断是否有相同的 key
            if let existValue = parameters[item.name], let value = item.value {
                
                // 将相同 key 的值存入数组中
                if var existValue = existValue as? [Any] {
                    existValue.append(value)
                    parameters[item.name] = existValue
                } else {
                    parameters[item.name] = [existValue, value]
                }
                
            } else {
                parameters[item.name] = item.value
            }
        }
        
        // 返回解析后的参数字典
        return parameters
    }
}
