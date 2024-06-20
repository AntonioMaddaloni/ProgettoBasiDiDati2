//
//  AnimeView.swift
//  animeHub
//
//  Created by Antonio De Lucia on 14/06/24.
//

import SwiftUI

struct AnimeView: View {
    
    @ObservedObject var asyncManager = ManagerViewModel()
    @State var firstApper : Bool = true
    var prova : String = "chevron.left"
    @State private var searchText = ""
  
    
    
    var body: some View {
        NavigationView {
            VStack {
                List(self.asyncManager.listAnime, id: \.self) { anime in
                    NavigationLink(destination: AnimeInfoView(asyncManager: self.asyncManager, animeInfo: anime)) {
                        VStack(alignment: .leading) {
                            Text(anime.title ?? "")
                                .foregroundColor(.red)
                                .font(.headline)
                        }
                    }
                }
                .searchable(text: $searchText).onChange(of: searchText){ if searchText.isEmpty {
                    Task{
                        await self.asyncManager.searchAnime(token: self.asyncManager.token, search: "", skip: 1)
                    }
                } else {
                    
                    Task{
                        await self.asyncManager.searchAnime(token: self.asyncManager.token, search: searchText, skip: 1)
                    }
                }}
                .listStyle(InsetGroupedListStyle())
                HStack{
                    Button(action: {
                        Task {
                            if self.asyncManager.skipPagine > 0 {
                                self.asyncManager.skipPagine -= 1
                                await self.asyncManager.searchAnime(token: self.asyncManager.token, search: searchText, skip: self.asyncManager.skipPagine)
                            }
                            
                            else {
                                self.asyncManager.skipPagine=1
                            }
                        }
                    }) {
                        if (self.asyncManager.skipPagine > 1)
                        {
                            Image(systemName: "chevron.left")
                                .font(.title)
                        }
                    }
                    Text(String(self.asyncManager.skipPagine))
                        .font(.title)
                    Button(action: {
                        Task{
                            self.asyncManager.skipPagine = self.asyncManager.skipPagine + 1
                            await self.asyncManager.searchAnime(token: self.asyncManager.token, search: searchText, skip: self.asyncManager.skipPagine)
                        }
                    }
                    ) {
                        if(self.asyncManager.listAnime.isEmpty){
                            Image(systemName: "")
                                .font(.title)
                        }
                        else {
                            Image(systemName: "chevron.right")
                                .font(.title)
                        }
                    }
                }
                
                
            }
            
            .navigationTitle("Lista Anime")
            .onAppear {
                Task {
                    if(firstApper){
                        await asyncManager.getAnime(token: asyncManager.token, skip: self.asyncManager.skipPagine)
                        firstApper=false
                    }
                    
                }
            }
        }
        
    }
}

#Preview {
    AnimeView()
}
