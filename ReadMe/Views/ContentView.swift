//
//  ContentView.swift
//  ReadMe
//
//  Created by Deepanjan De on 1/10/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var library: Library
    @State var addingNewBook: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Button {
                    addingNewBook.toggle()
                } label: {
                    Spacer()
                    
                    VStack (spacing: 6) {
                        Image(systemName: "book.circle")
                            .font(.system(size: 60))
                        Text("Add New Book")
                            .font(.title2)
                    }
                    
                    Spacer()
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.vertical, 8)
                
                switch library.sortStyle {
                case .manual:
                    ForEach(Section.allCases, id: \.self) {
                        SectionView(section: $0)
                    }
                case .title, .author:
                    TitleAndAuthorView()
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu("Sort") {
                        Picker("Sort Style", selection: $library.sortStyle) {
                            ForEach(SortStyle.allCases, id: \.self) { (sortStyle) in
                                Text("\(sortStyle)".capitalized)
                            }
                        }
                    }
                }
                ToolbarItem(content: EditButton.init)
            }
            .navigationBarTitle("My Library")
        }.sheet(isPresented: $addingNewBook) {
            AddBook(book: .init())
        }
    }
}

private struct BookRow: View {
    @ObservedObject var book: Book
    @EnvironmentObject var library: Library
    
    var body: some View {
        NavigationLink(
            destination: DetailView(book: book)
        ) {
            HStack {
                Book.Image(
                    uiImage: library.uiImages[book],
                    title: book.title,
                    size: 80,
                    cornerRadius: 12
                )
                VStack (alignment: .leading){
                    TitleAndAuthorStack(book: book, titleFont: .title2, authorFont: .title3)
                    if !book.microReview.isEmpty {
                        Spacer()
                        Text(book.microReview)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .lineLimit(1)
                Spacer()
                BookmarkButton(book: book)
                    .buttonStyle(BorderlessButtonStyle())
            }
            .padding(.vertical, 8)
        }
    }
}

private struct SectionView: View {
    let section: Section
    @EnvironmentObject var library: Library
    
    var title: String {
        switch section {
        case .readMe:
            return "Read Me!"
        case .finished:
            return "Finished!"
        }
    }
    var body: some View {
        if let books = library.manuallySortedBooks[section] {
            SwiftUI.Section(
                header:
                    ZStack {
                        Image("BookTexture")
                        .resizable()
                        .scaledToFit()
                        Text(title)
                            .font(.custom("American Typewriter", size: 24))
                    }
                    .listRowInsets(.init())
            ) {
                ForEach(books) {
                    BookRow(book: $0)
                }
                .onDelete { indexSet in
                    library.deleteBooks(atOffsets: indexSet, section: section)
                }
                .onMove { indices, newOffset in
                    library.moveBooks(oldOffsets: indices, newOffset: newOffset, section: section)
                }
            }
        }
    }
}

private struct TitleAndAuthorView: View {
    @EnvironmentObject var library: Library
    
    var body: some View {
        ForEach(library.sortedBooks) {
            BookRow(book: $0)
        }
        .onDelete { indexSet in
            library.deleteBooks(atOffsets: indexSet, section: nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Library())
            .previewedInAllColorSchemes
    }
}


//struct BookRow: View {
//    var body: some View {
//        HStack {
//            Book.Image(title: Book().title )
//            Text("Title")
//                .font(.title2)
//        }
//    }
//}


