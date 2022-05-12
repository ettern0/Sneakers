import Fluent
import Vapor

final class Sneaker: Model, Content {
    static let schema = "sneakers"
    
    @ID(key: .id)
    var id: UUID?

    init() { }

    init(id: String) {
        self.id = UUID(uuidString: id)
    }
}
