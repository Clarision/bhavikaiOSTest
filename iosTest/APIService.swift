//
//  APIService.swift
//  iosTest
//
//  Created by macmini on 24/12/20.
//

import Foundation
import RxSwift

public enum RequestType: String {
    case GET, POST, PUT,DELETE
}

class APIService {
    
    let baseURL = URL(string: "http://imaginato.mocklab.io/login")!
    var method = RequestType.POST
    var parameters = [String: String]()
    
    
    func request(with baseURL: URL) -> URLRequest
    {
        let jsonData = try? JSONSerialization.data(withJSONObject: self.parameters)
        var request = URLRequest(url: baseURL)
        request.httpMethod = method.rawValue
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}


class APICalling {
    // create a method for calling api which is return a Observable
    func send(apiRequest: APIService) -> Observable<LoginModelResponse>
    {
        return Observable.create { observer in
            let request = apiRequest.request(with: apiRequest.baseURL)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                do
                {
                    let model: LoginModelResponse = try JSONDecoder().decode(LoginModelResponse.self, from: data ?? Data())
                    observer.onNext(model)
                }
                catch let error
                {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create
            {
                task.cancel()
            }
        }
    }
}
