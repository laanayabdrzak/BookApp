//
//  MultipleSelectionRow.swift
//  BookAppMVVM
//
//  Created by LAANAYA Abderrazak on 12/7/2023.
//

import SwiftUI

struct MultipleSelectionRow: View {
    var book: Book
    var isSelected: Bool
    var imageName: String = "cart.badge.plus"
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                AsyncImage(
                    url: URL(string: book.cover)!,
                    placeholder: { Text("Loading ...")
                            .multilineTextAlignment(.center)
                            .font(.caption)
                            .foregroundColor(.accentColor) },
                    image: { Image(uiImage: $0).resizable() }
                )
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding(.vertical, 4)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(book.title)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                    
                    Text("\(book.price) €")
                        .font(.subheadline)
                        .lineLimit(8)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: self.imageName)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40, alignment: .trailing)
                
                if self.isSelected {
                    //imageName = "cart.fill.badge.plus"
                }
            }
        }
    }
}
