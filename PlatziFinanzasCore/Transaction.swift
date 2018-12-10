import Foundation

public enum TransactionCategory {
    case earn, expend
}

public struct Transaction {
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
}

extension Transaction: Hashable {
    public var hashValue: Int {
        return uuid.hashValue
    }
}
