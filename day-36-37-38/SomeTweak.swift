import SwiftUI
struct SomeTweak: View {
    @ObservedObject var expenses = Expenses()
    @State private  var showAddView = false
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name).font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text("$\(item.amount)").foregroundColor(setColor(amount: item.amount))
                    }
                }.onDelete { indexSet in
                    self.expenses.items.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("iExpenses")
              
            .navigationBarItems(leading: EditButton(), trailing:
             Button(action: {
                self.showAddView = true
            }) {Image(systemName: "plus")}
                .sheet(isPresented: $showAddView) {
                    AddView(expenses: self.expenses)
                }
                                
            )
        }
    }
    func setColor(amount: Int) -> Color {
        if amount >= 100 {
            return .red
        }
        else if amount < 100 {
            return .pink

        }
        else if amount <= 10 {
            return .green
        }
        return .gray
    }
}

struct SomeTweak_Previews: PreviewProvider {
    static var previews: some View {
        SomeTweak()
    }
}
struct ExpenseItem : Identifiable, Codable{
    var id      = UUID()
    let name    : String
    let type    : String
    let amount  : Int
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
             let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.setValue(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
            }
        }
        self.items = []
    }
    
}
