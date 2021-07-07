//
//  API.swift
//  LearnRxSwift
//
//  Created by Thân Văn Thanh on 02/07/2021.
//

import Foundation
import RxCocoa
import RxSwift

class APIRequest {
    let baseURL = URL(string: "https://api.github.com/search/users?q=vn")
    var method = RequestType.GET
    var parameters = [String:String]()
    
    func request(with baseURL : URL) -> URLRequest{
        var request = URLRequest(url: baseURL)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
}


class APICalling{
    
    func send<T:Codable>(apiRequest : APIRequest) ->Observable<T>{
        return Observable<T>.create { observer in
            let request = apiRequest.request(with: apiRequest.baseURL!)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do{
                    let model : DataGit = try JSONDecoder().decode(DataGit.self, from: data ?? Data())
                    observer.onNext(model.items as! T)
                }catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
