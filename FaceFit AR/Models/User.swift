import Foundation

struct User: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    
    init(id: String = UUID().uuidString, name: String, email: String,) {
        self.id = id
        self.name = name
        self.email = email
    }
}
