import SwiftUI

struct CalculatorOverlay: View {
    @Binding var isPresented: Bool
    @Binding var result: Decimal
    @State private var expression: String = ""

    private let buttons: [[String]] = [
        ["7","8","9","/"],
        ["4","5","6","x"],
        ["1","2","3","-"],
        ["0",".","C","+"],
        ["="]
    ]

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(expression).font(.title2).lineLimit(1).frame(maxWidth: .infinity, alignment: .trailing)
            }.padding().background(Color(UIColor.systemFill)).cornerRadius(12)
            ForEach(0..<buttons.count, id: \.self) { r in
                HStack(spacing: 12) {
                    ForEach(buttons[r], id: \.self) { key in
                        Button(action: { tap(key) }) {
                            Text(key).frame(maxWidth: .infinity).padding(16)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            Button("Đóng") { isPresented = false }.buttonStyle(.bordered)
        }
        .padding()
    }

    private func tap(_ key: String) {
        switch key {
        case "C": expression = ""
        case "=":
            if let value = evaluate(expression) {
                result = value
                isPresented = false
            }
        default: expression.append(key)
        }
    }

    private func evaluate(_ exp: String) -> Decimal? {
        let replaced = exp.replacingOccurrences(of: "x", with: "*")
        let expr = NSExpression(format: replaced)
        if let v = expr.expressionValue(with: nil, context: nil) as? NSNumber {
            return Decimal(string: v.stringValue)
        }
        return nil
    }
}
