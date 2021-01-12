//
//  AddBook.swift
//  ReadMe
//
//  Created by Deepanjan De on 1/11/21.
//

import SwiftUI

struct AddBook: View {
    @ObservedObject var book: Book
    @State var image: UIImage? = nil
    @EnvironmentObject var library: Library
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    TextField(book.title, text: $book.title)
                        .foregroundColor(.secondary)
                    Divider()
                    TextField(book.author, text: $book.author)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                .padding(.leading)
                .padding(.trailing)
                
                DetailBodyView(
                    book: book,
                    image: $image
                )
            }
            .navigationTitle("Got a new book?")
            .toolbar {
                ToolbarItem(placement: .status) {
                    Button("Add to Library") {
                        library.addNewBook(book, image: image)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(
                        [book.title, book.author].contains(where: \.isEmpty)
                    )
                }
            }
        }
    }
}

struct AddBook_Previews: PreviewProvider {
    static var previews: some View {
        AddBook(book: .init()).environmentObject(Library())
    }
}
