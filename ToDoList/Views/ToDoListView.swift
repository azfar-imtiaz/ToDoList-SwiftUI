//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Azfar Imtiaz on 2023-06-15.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ToDoListView: View {
    @StateObject var viewModel: ToDoListViewViewModel
    @FirestoreQuery var items: [ToDoListItem]
    
    private let userID: String
    init(userID: String) {
        self.userID = userID
        self._items = FirestoreQuery(
            collectionPath: "users/\(userID)/ToDos")
        // we initialize this like so here because we want it to store user ID
        self._viewModel = StateObject(
            wrappedValue: ToDoListViewViewModel(userID: userID))
    }
    
    var body: some View {
        NavigationView {
            VStack() {
                Spacer()
                Text("Incomplete Tasks")
                    .font(.title2)
                List(items) { item in
                    if !item.isDone {
                        ToDoListItemView(item: item)
                            .swipeActions {
                                Button("Delete") {
                                    viewModel.delete(itemID: item.id)
                                }
                                .tint(Color.red)
                            }
                            .padding()
                    }
                }
                .listStyle(.plain)
                
                Spacer()
                Text("Completed Tasks")
                    .font(.title2)
                List(items) { item in
                    if item.isDone {
                        ToDoListItemView(item: item)
                            .swipeActions {
                                Button("Delete") {
                                    viewModel.delete(itemID: item.id)
                                }
                                .tint(Color.red)
                            }
                            .padding()
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("To Do List")
            .toolbar {
                Button {
                    // action
                    viewModel.showingNewItemView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewItemView(newItemPresented: $viewModel.showingNewItemView)
            }
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(userID: "5lbdg6FQaMhItGAq1AKwbCMCkfq1")
    }
}
