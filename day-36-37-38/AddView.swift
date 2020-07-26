//
//  AddView.swift
//  day-36-37-38
//
//  Created by Jhon Khan on 26/07/2020.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var shouldDismiss
    @ObservedObject var expenses : Expenses
    @State private var name        = ""
    @State private var type        = "Personal"
    @State private var amount      = ""
    @State private var isValid     = false
    
    static let types = ["Business" , "Personal"]
    var body: some View {
        NavigationView {
            Form{
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(AddView.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save", action: {
                if let actualAmount = Int(self.amount) {
                    let exp = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(exp)
                    self.shouldDismiss.wrappedValue.dismiss()
                }
                else {
                    self.isValid = true
                }
            })).alert(isPresented: $isValid) {
                Alert(title: Text("Error!"), message: Text("Please Enter a valid input"), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
