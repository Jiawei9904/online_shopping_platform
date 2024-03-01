//
//  SimilarProductsTab.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/22/23.
//

import SwiftUI

struct SimilarProductsTab: View {
    @ObservedObject var viewModel: ItemDetailsViewModel
    let itemId: String

    @State private var selectedSortOption: String = "Default"
    @State private var selectedOrder: Bool = true // true for Ascending, false for Descending

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack (alignment: .leading) {
            if viewModel.isLoading{
                Spacer()
                ProgressView("Please wait...")
            }else{
                Text("Sort By")
                    .font(.headline)
                    .padding(.horizontal)
                
                Picker("Sort By", selection: $selectedSortOption) {
                    Text("Default").tag("Default")
                    Text("Name").tag("Name")
                    Text("Price").tag("Price")
                    Text("Days Left").tag("DaysLeft")
                    Text("Shipping").tag("Shipping")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                if selectedSortOption != "Default" {
                    Text("Order")
                        .font(.headline)
                        .padding([.horizontal, .top])
                    Picker("Order", selection: $selectedOrder) {
                        Text("Ascending").tag(true)
                        Text("Descending").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                }
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(sortedItems, id: \.id) { item in
                            SimilarItemView(item: item)
                        }
                    }
                    .padding()
                }
            }
            Spacer()
        }
        .onAppear {
            viewModel.fetchSimilarItems(itemId: itemId)
        }
        .onChange(of: selectedSortOption) { newValue in
            if newValue != "Default" {
                // when change the tab, ascending always the default
                selectedOrder = true
            }
        }
        .onChange(of: selectedOrder) { _ in }
    }

    private var sortedItems: [SimilarItem] {
        switch selectedSortOption {
        case "Name":
            return viewModel.similarItems.sorted {
                selectedOrder ? $0.title < $1.title : $0.title > $1.title
            }
        case "Price":
            return viewModel.similarItems.sorted {
                selectedOrder ? $0.buyItNowPrice.valueAsDouble < $1.buyItNowPrice.valueAsDouble :
                $0.buyItNowPrice.valueAsDouble > $1.buyItNowPrice.valueAsDouble
            }
        case "DaysLeft":
            return viewModel.similarItems.sorted {
                selectedOrder ? $0.daysLeft < $1.daysLeft : $0.daysLeft > $1.daysLeft
            }
        case "Shipping":
            return viewModel.similarItems.sorted {
                selectedOrder ? $0.shippingCost.valueAsDouble < $1.shippingCost.valueAsDouble :
                $0.shippingCost.valueAsDouble > $1.shippingCost.valueAsDouble
            }
        default:
            return viewModel.similarItems
        }
    }


}



struct SimilarItemView: View {
    let item: SimilarItem

    var body: some View {
        Button(action: {
            if let url = URL(string: item.viewItemURL), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }) {
            // content
            VStack(alignment: .leading, spacing: 4) {
                
                AsyncImage(url: URL(string: item.imageURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                             .aspectRatio(contentMode: .fill)
                    case .failure:
                        ProgressView() 
                    case .empty:
                        ProgressView() 
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 150, height: 150)
                .cornerRadius(8)

                Text(item.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.black)

                HStack {
                    Text("$\(item.shippingCost.__value__)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(item.daysLeft) days left")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                HStack {
                    Spacer()
                    Text("$\(item.buyItNowPrice.__value__)")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}





