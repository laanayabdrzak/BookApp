//
//  ContentView.swift
//  BookAppMVVM
//
//  Created by LAANAYA Abderrazak on 11/7/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selections = Set<Book>()
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                contentList
            }
            .navigationTitle("Fantasy Books")
        }
    }
    
    private var contentList: some View {
        Group {
            if viewModel.books.isEmpty {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white)
            } else {
                List(viewModel.books, id: \.self) { book in
                    MultipleSelectionRow(book: book, isSelected: selections.contains(book)) {
                        toggleSelection(for: book)
                    }
                }
                .listStyle(PlainListStyle())
                VStack {
                    applyDiscountButton
                    summaryView
                }
                .background(Color.gray.opacity(0.1))
            }
        }
    }
    
    private var applyDiscountButton: some View {
        Button(action: { viewModel.applyDiscount(for: selections) }) {
            Text("Apply discount code")
                .padding()
        }
        .disabled(selections.isEmpty)
    }
    
    private var summaryView: some View {
        HStack {
            Text("Summary").bold()
            Spacer()
            VStack {
                summaryRow(title: "Subtotal:", value: "\(selections.map(\.price).reduce(0, +)) €")
                summaryRow(title: "Total:", value: "\(viewModel.discountedPrice) €", isHighlighted: true)
            }
            .frame(width: 200)
        }
        .padding()
    }
    
    private func summaryRow(title: String, value: String, isHighlighted: Bool = false) -> some View {
        HStack {
            Text(title).fontWeight(.semibold)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(isHighlighted ? .accentColor : .primary)
        }
    }
    
    private func toggleSelection(for book: Book) {
        if selections.contains(book) {
            selections.remove(book)
        } else {
            selections.insert(book)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
