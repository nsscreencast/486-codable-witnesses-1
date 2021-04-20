
//protocol Discountable {
//    func discounted() -> Double
//}
//
struct Purchase {
    var amount: Double
    var shippingAmount: Double
    
//    func discounted() -> Double {
//        amount * 0.9
//    }
}

struct Discounting<A> {
    let discounted: (A) -> Double
}

//extension Discounting where A == Purchase {
//    static let tenPercentOff = Discounting<Purchase> { purchase in
//        purchase.amount * 0.9
//    }
//
//    static let fiveDollarsOff = Discounting<Purchase> { p in
//        p.amount - 5
//    }
//}

// MAP          (A) -> B  --> ?<B>
// CONTRAMAP    (B) -> A  --> ?<B>
// PULLBACK

extension Discounting {
    func pullback<B>(_ f: @escaping (B) -> A) -> Discounting<B> {
        .init { other -> Double in
            self.discounted(f(other))
        }
    }
}

extension Discounting where A == Double {
    static let tenPercentOff = Self { amount in
        amount * 0.9
    }
    
    static let fiveDollarsOff = Self { amount in
        amount - 5
    }
}

extension Discounting where A == Purchase {
    static let tenPercentOff: Self = Discounting<Double>
        .tenPercentOff
        .pullback(\.amount)
    
    static let tenPercentOffShipping: Self = Discounting<Double>
            .tenPercentOff
            .pullback(\.shippingAmount)
}

func printDiscount<D>(_ item: D, with discount: Discounting<D>) -> String {
    let discount = discount.discounted(item)
    return "Discount: \(discount)"
}

let item = Purchase(amount: 95.00, shippingAmount: 10.0)
printDiscount(item, with: .tenPercentOffShipping)
printDiscount(item, with: Discounting<Double>.fiveDollarsOff.pullback(\.amount))

