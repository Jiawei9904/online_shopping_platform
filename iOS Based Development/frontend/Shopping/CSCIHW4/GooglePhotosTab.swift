//
//  GooglePhotosTab.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/22/23.
//

import SwiftUI

//struct GooglePhotosTab: View {
//    @ObservedObject var viewModel: ItemDetailsViewModel
//    var itemTitle: String
//
//    var body: some View {
//            VStack {
//                HStack {
//                    Text("Powered by")
//                        .font(.headline)
//                        .foregroundColor(.black)
//
//                    Image("google")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 40)
//                }
//                if viewModel.isLoading {
////                    ProgressView()
//                    ProgressView("Please wait...")
//                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
//                } else if !viewModel.googlePhotos.isEmpty {
//                    ScrollView{
//                        ForEach(viewModel.googlePhotos, id: \.self) { photoUrl in
//                            AsyncImage(url: photoUrl) { image in
//                                image.resizable()
//                            } placeholder: {
//                                ProgressView()
//                            }
//                            .aspectRatio(contentMode: .fit)
//                            .padding()
//                        }
//                    }
//                    
//                } else if let errorMessage = viewModel.errorMessage {
//                    Text(errorMessage)
//                } else {
//                    Text("No images found.")
//                }
//            }
//        .clipped()
//        .onAppear {
//            viewModel.fetchGooglePhotos(for: itemTitle)
//        }
//        .padding(.horizontal)
//    }
//}
struct GooglePhotosTab: View {
    @ObservedObject var viewModel: ItemDetailsViewModel
    var itemTitle: String

    var body: some View {
        VStack {
            // 始终固定在顶部的 HStack
            HStack {
                Text("Powered by")
                    .font(.headline)
                    .foregroundColor(.black)

                Image("google")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
            }

            if viewModel.isLoading {
                Spacer()
                ProgressView("Please wait...")
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .init(horizontal: .center, vertical: .center))
                
            } else if !viewModel.googlePhotos.isEmpty {
                ScrollView {
                    ForEach(viewModel.googlePhotos, id: \.self) { photoUrl in
                        AsyncImage(url: photoUrl) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250)
                        .padding()
                    }
                }
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                } else {
                    Text("No images found.")
                }

            Spacer()
        }
        .clipped()
        .onAppear {
            viewModel.fetchGooglePhotos(for: itemTitle)
        }
        .padding(.horizontal)
    }
}


