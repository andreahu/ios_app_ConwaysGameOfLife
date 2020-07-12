//
//  Fetcher.swift
//  Final Proj
//
//  Created by AH.
//  Copyright 
//

import Foundation

let ConfigurationURL = "https://www.dropbox.com/s/i4gp5ih4tfq3bve/S65g.json?dl=1"

//this class is for feching data from web
class Fetcher: NSObject, URLSessionDelegate {
    
    var handler: FetchCompletionHandler?
    
    //create the session
    func session() -> URLSession {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration,
                          delegate: self,
                          delegateQueue: nil)
    }
    
    //take the chanllenge and perform handling
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
        ) {
        NSLog("\(#function): Session received authentication challenge")
        completionHandler(.performDefaultHandling,nil)
    }
}

enum EitherOr {
    case success(Data)
    case failure(String)
}

extension Fetcher {
    typealias FetchCompletionHandler = (EitherOr) -> Void
    
    //func fetch: pass in an URL, hand me back with the data that you downloaded from the url
    func fetch(url: URL, completionHandler completion: @escaping FetchCompletionHandler) {
        let task = session().dataTask(with: url) { (data: Data?, response: URLResponse?, netError: Error?) in
            //three things could happen: 1.get the data; 2.succesully connected to the server on the other end but not getting data; 3.Can't get connected; So I need to make them all optional since I don't know which one will happen
            guard let response = response as? HTTPURLResponse, netError == nil else {//if I have a response and the netError is nil, I can go on. If I don't have or netError is not nil, then hand back the failure message
                return completion(.failure(netError!.localizedDescription))
            }
            guard response.statusCode == 200 else {//200 is "here you go, here's the thing" :D
                return completion(.failure("\(response.description)"))
            }
            guard let data = data  else {
                return completion(.failure("valid response but no data"))
            }
            completion(.success(data))//pass me the data
        }
        task.resume()
    }
}
