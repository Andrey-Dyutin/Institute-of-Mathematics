//
//  Request.swift
//  IM
//
//  Created by Андрей Дютин on 14.08.2020.
//  Copyright © 2020 Андрей Дютин. All rights reserved.
//

import Foundation

class Request {
    
    func get() {
        guard let url =
            URL(string:"https://kpfu.ru/subject_schedule_web.schedule_type_study") else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                let response = response
                else { return }
            print(data)
            print(response)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func post() {
        guard let url = URL(string:"") else { return }
        let userData = [" ": " "]//словарь
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, erroe) in
            guard
                let data = data,
                let response = response
                else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
            print(response)
        }.resume()
    }
    
}
