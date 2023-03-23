//
//  NetworkServiceHelper.swift
//  Vero-Digital-Solutions-Case
//
//  Created by Ali Görkem Aksöz on 23.03.2023.
//

import Foundation

let headers = [
  "Authorization": "Basic QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz",
  "Content-Type": "application/json"
]
let parameters = [
  "username": "365",
  "password": "1"
] as [String : Any]

let loginUrl = "https://api.baubuddy.de/index.php/login"
let urlString = "https://api.baubuddy.de/dev/index.php/v1/tasks/select"
