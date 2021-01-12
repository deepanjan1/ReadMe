//
//  DetailView.swift
//  ReadMe
//
//  Created by Deepanjan De on 1/10/21.
//
import class PhotosUI.PHPickerViewController
import SwiftUI

struct DetailView: View {
    @ObservedObject var book: Book
    @EnvironmentObject var library: Library
    @State var isEditing = false
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack (spacing: 16) {
                BookmarkButton(book: book)
                TitleAndAuthorStack(book: book, titleFont: .title, authorFont: .title2)
            }
            DetailBodyView(
                book: book,
                image: $library.uiImages[book]
            )
        }
        .padding()
    }
}

//struct DetailBodyView: View {
//    @ObservedObject var book: Book
//    @Binding var image: UIImage?
//    @State var showingImagePicker: Bool = false
//    @State var showingDeleteImage: Bool = false
//    
//    var body: some View {
//        VStack {
//            Divider()
//            TextField("Enter Review", text: $book.microReview)
//            Divider()
//                .padding(.bottom)
//            Book.Image(
//                uiImage: image,
//                title: book.title,
//                cornerRadius: 16
//            ).scaledToFit()
//            HStack() {
//                if image != nil {
//                    Spacer()
//                    Button("Delete Image") {
//                        showingDeleteImage = true
//                    }
//                }
//                Spacer()
//                Button("Update Image") {
//                    showingImagePicker = true
//                }
//                Spacer()
//            }
//        }.padding()
//        Spacer()
//        .sheet(isPresented: $showingImagePicker) {
//            PHPickerViewController.View(image: $image)
//        }
//        .alert(isPresented: $showingDeleteImage) {
//            .init(title: .init("Delete image for \(book.title)?"), primaryButton: .destructive(.init("Delete")) {
//                image = nil
//            }, secondaryButton: .cancel())
//        }
//    }
//}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(book: .init())
            .environmentObject(Library())
            .previewedInAllColorSchemes
    }
}
