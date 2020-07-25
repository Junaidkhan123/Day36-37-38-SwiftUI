//
//  ContentView.swift
//  day-36-37-38
//
//  Created by Jhon Khan on 25/07/2020.
//

import SwiftUI

class Student: ObservableObject{
    @Published var firstName = "Junaid"
    @Published var lastName  = "khan"
}

struct SecondView: View{
    @Environment(\.presentationMode) var presentationMode
    var name : String
    var body: some View {
        VStack {
            Text("Hello \(name) How are you?")
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Dismiss ME")
            })
        }
    }
}

struct ContentView: View {
    @ObservedObject  var student = Student()
    @State private var showPresenation = false
    var body: some View {
        VStack {
            Text("\(student.firstName) \(student.lastName)")
                .padding()
            TextField("Please Enter first name", text: $student.firstName)
            TextField("Last Name", text: $student.lastName)
            
            Button(action: {
                self.showPresenation.toggle()
            }, label: {
                Text("Show Second View")
            }).sheet(isPresented: $showPresenation) {
                SecondView(name: "Junaid")
            }
        
    }
}
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DeleteView: View{
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    var body: some View {
        NavigationView {
            VStack{
                List {
                    ForEach(numbers,id: \.self) {
                        Text("\($0)")
                    }.onDelete(perform: removeRows)
                }
                
                Button("Add Number") {
                    self.numbers.append(self.currentNumber)
                    self.currentNumber += 1
                }
            }
            .navigationBarItems(leading: EditButton())
        }
    }
    
    func removeRows(at offset : IndexSet)  {
        numbers.remove(atOffsets: offset)
    }
}
