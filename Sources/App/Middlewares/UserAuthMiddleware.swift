//
//  UserAuthMiddleware.swift
//  
//
//  Created by San Engineer on 11/01/22.
//

import Vapor

final class UserAuthMiddleware: Middleware {
    
    let authUrl: String = Environment.get("AUTH_URL")!

    
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard let token = request.headers.bearerAuthorization else {
            return request.eventLoop.future(error: Abort(.unauthorized))
        }

        //debug
        print("AUTH_URL: \(authUrl)")
        
        return request
            .client
            .post("\(authUrl)/user/auth/authenticate", beforeSend: {
                authRequest in
                
                try authRequest.content.encode(AuthenticateData(token: token.token))
            })
            .flatMapThrowing { clientResponse in
                guard clientResponse.status == .ok else {
                    if clientResponse.status == .unauthorized {
                        throw Abort (.unauthorized)
                    } else {
                        throw Abort(.internalServerError)
                    }
                }
                
                let user = try clientResponse.content.decode(User.self)

                //debug
                print("\n", "RESEPONSE:\n", clientResponse, "\n")
                print("\n", "USER:", user, "\n")

                request.auth.login(user)
            }

            .flatMap {
                return next.respond(to: request)
            }
    }
}

struct AuthenticateData: Content {
    let token: String
}
