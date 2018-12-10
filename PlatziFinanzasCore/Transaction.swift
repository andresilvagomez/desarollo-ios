import Foundation

public enum TransactionCategory {
    case earn, expend
}

public class Transaction {
    var uuid = UUID()
    var value: Float
    var category: TransactionCategory
    var name: String
    var date: Date
    
    public init(value: Float, category: TransactionCategory, name: String, date: Date) {
        self.value = value
        self.category = category
        self.name = name
        self.date = date
    }
    
    public func data() -> [String: Any]? {
        let jsonEncoder = JSONEncoder()
        guard let data = try jsonEncoder.encode(self) else {
            return nil
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        
        return json
    }
}

extension Transaction: Hashable {
    public var hashValue: Int {
        return uuid.hashValue
    }
}
