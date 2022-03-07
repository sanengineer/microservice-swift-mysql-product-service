import Vapor

struct User: Content {
    let id: UUID
    let name: String
    let username: String
    let role_id: Int
    
    init(id: UUID, name: String, username: String, role_id:Int) {
        self.id = id
        self.name = name
        self.username = username
        self.role_id = role_id
    }
}

extension User: Authenticatable {}

