//
//  SearchFormView.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/14/23.
//

import SwiftUI

struct SearchFormView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var showingSuggestions = false
    @StateObject private var wishListViewModel = WishListViewModel()
    @StateObject var favoriteManager = FavoriteManager()


    let categories = ["All", "Art", "Baby", "Books", "Clothing, Shoes & Accessories", "Computers/Tablets & Networking", "Health & Beauty", "Music", "Video Games & Consoles"]
    var body: some View {
        NavigationView{
            ZStack{
                Form {
                    HStack {
                        Text("Keyword:")
                        TextField("Required", text: $viewModel.keyword)
                    }
                    
                    Picker("Category", selection: $viewModel.selectedCategory) {
                                        ForEach(categories, id: \.self) { category in
                                            Text(category).tag(category)
                                        }
                                    }.pickerStyle(MenuPickerStyle())
                    
                    VStack(alignment: .leading) {
                        Text("Condition") // Set the font of the title
                        HStack {
                            CheckboxView(label: "Used", isChecked: $viewModel.conditionUsed)
                            CheckboxView(label: "New", isChecked: $viewModel.conditionNew)
                            CheckboxView(label: "Unspecified", isChecked: $viewModel.conditionUnspecified)
                        }.frame(maxWidth: .infinity) // keep in center
                    }
                    
                    VStack(alignment: .leading){
                        Text("Shipping")
                        HStack {
                            CheckboxView(label: "Pickup", isChecked: $viewModel.shippingPickup)
                            CheckboxView(label: "Free Shipping", isChecked: $viewModel.shippingFree)
                        }.frame(maxWidth: .infinity)
                    }
                    
                    HStack {
                        Text("Distance:")
//                        TextField("", text: $viewModel.distance)
//                                .onAppear {
//                                    // default value
//                                    viewModel.distance = "10"
//                                }
//                                .foregroundColor(.gray)
                        TextField("", text: $viewModel.distance, onEditingChanged: { isEditing in
                            viewModel.isDistanceEdited = isEditing || !viewModel.distance.isEmpty
                        })
                        .foregroundColor(viewModel.isDistanceEdited ? .black : .gray)

                        }
                    Toggle("Custom location", isOn: $viewModel.customLocation)
                        .onChange(of: viewModel.customLocation) {
                            if !viewModel.customLocation {
                                // when custom location is inactive, call getCurrentLocation method
                                viewModel.locationFetcher.getCurrentLocation()
                                
                            }
                        }
    //                HStack{
    //                    Text("Current Location: \(viewModel.locationFetcher.currentLocation)")
    //                }
                    //  Zipcode field that appears when customLocation is ON
    //                if customLocation {
    //                    HStack{
    //                        Text("ZipCode:")
    //                        TextField("Enter Zipcode", text: $zipcode)
    //                        .textFieldStyle(RoundedBorderTextFieldStyle())
    //                        .keyboardType(.numberPad)
    //                    }
    //                }
                    if viewModel.customLocation {
                        HStack {
                            Text("ZipCode:")
                            TextField("Required", text: $viewModel.zipcode)
                                .onChange(of: viewModel.zipcode) { _ in
                                    viewModel.fetchPostalCodeSuggestions(for: viewModel.zipcode)
                                    showingSuggestions = viewModel.isZipCodeValid
                                }
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                    }
                    HStack {
                        Button(action: {
                            // Submit action
                            viewModel.onSearchSubmit()
                        }) {
                            Text("Submit")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }.buttonStyle(BorderlessButtonStyle())
                        Spacer()
                        Button(action: {
                            // Clear action
                            viewModel.clearForm()
                        }) {
                            Text("Clear")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                    
                    Section{
                        if viewModel.showSearchResults {
                                
                            SearchResultsView(searchResults: $viewModel.searchResults, viewModel: viewModel, favoriteManager: favoriteManager)
                            
                            
                        }
                    }
                }.navigationBarTitle("Product Search")
                .onAppear {
                    // initial: customLocation == false, get currentLocation
                    if !viewModel.customLocation {
                        viewModel.locationFetcher.getCurrentLocation()
                    }
                }
                .sheet(isPresented: $showingSuggestions) {
                    PostalCodeSuggestionView(
                    isPresented: $showingSuggestions,
                    selectedZipCode: $viewModel.zipcode,
                    postalCodeSuggestions: viewModel.postalCodeSuggestions
                    )
                }
//                .alert(isPresented: $viewModel.showErrorAlert) {
//                    Alert(title: Text("Error"),
//                    message: Text(viewModel.errorMessage),
//                    dismissButton: .default(Text("OK")))
//                }
                .navigationBarItems(trailing:
                    NavigationLink(destination: WishListView(viewModel: wishListViewModel)) {
                        Image(systemName: "heart.circle")
                    }
                )
                // 自定义 Toast 视图，当 showToast 为 true 时显示
                if viewModel.showErrorAlert || favoriteManager.toastMessage != "" {
                    if(viewModel.showErrorAlert){
                        ToastView(message: viewModel.errorMessage)
                            .onAppear {
                                // 设置 Toast 几秒钟后自动消失
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    viewModel.showErrorAlert = false
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }else{
                        
                        ToastView(message: favoriteManager.toastMessage)
                            .onAppear {
                                // 设置 Toast 几秒钟后自动消失
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    favoriteManager.toastMessage = ""
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }
                                
                }
                
            }
        }
    }
}

struct CheckboxView: View {
    let label: String
    @Binding var isChecked: Bool

    var body: some View {
        Button(action: {
            self.isChecked.toggle()
        }) {
            HStack {
                Image(systemName: isChecked ? "checkmark.square" : "square")
                    .foregroundColor(isChecked ? .blue : .gray)
                Text(label)
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct SearchFormView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFormView()
    }
}

