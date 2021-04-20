protocol Discountable {
    func discounted() -> Double
}

struct Purchase {
    var amount: Double
    
    func discounted() -> Double {
        amount * 0.9
    }
}
