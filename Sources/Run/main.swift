//
//  main.swift
//
//
//  Created by Evgeny Serdyukov on 28.04.2022.
//


import App
import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
