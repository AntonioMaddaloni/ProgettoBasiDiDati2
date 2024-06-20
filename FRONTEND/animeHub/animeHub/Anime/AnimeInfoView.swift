//
//  AnimeInfoView.swift
//  animeHub
//
//  Created by Antonio De Lucia on 17/06/24.
//

import SwiftUI

struct AnimeInfoView: View {
    
    @ObservedObject var asyncManager = ManagerViewModel()
    var animeInfo : anime
    @State var validationMessage : String = ""
    @State var showAlert : Bool = false
    
    
    
    var body: some View {
        
        let imageUrl = self.asyncManager.singleAnime.img_url ?? "Unknown name"
        let synopsis = self.asyncManager.singleAnime.synopsis ?? "Unknown name"
        let aired = self.asyncManager.singleAnime.aired ?? "Unknown name"
        let episodes = self.asyncManager.singleAnime.episodes ?? 0
        let popularity = self.asyncManager.singleAnime.popularity ?? 0
        let score = self.asyncManager.singleAnime.score ?? 0
        let genre = self.asyncManager.singleAnime.genre ?? [""]
        
        VStack
        {
            Form{
                Section(header : Text(animeInfo.title)){
                        
                        if let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(20)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 400, height: 200)
                            
                            HStack{
                                Text("Score:")
                                    .bold()
                                Text(String(score))
                                    .foregroundStyle(Color.red)
                                Spacer()
                                Text("Popularity:")
                                    .bold()
                                Text(String(popularity))
                                    .foregroundStyle(Color.red)
                                /*Text(genre.joined(separator: ","))
                                 .foregroundStyle(Color.red)
                                 .padding()*/
                            }
                            
                            HStack{
                                Text("Synopsis:")
                                    .bold()
                                Spacer()
                                ScrollView {
                                     Text(synopsis)
                                         .foregroundStyle(Color.red)
                                 }
                                 .frame(height: 200)
                                
                            }
                            
                            HStack{
                                Text("Genre:")
                                    .bold()
                                Text(genre.joined(separator: ","))
                                    .foregroundStyle(Color.red)
                                    .padding()
                            }
                            
                            HStack{
                                Text("Aired:")
                                    .bold()
                               Text(aired)
                                    .foregroundStyle(Color.red)
                            }
                            
                            HStack{
                                Text("Episodes:")
                                    .bold()
                               Text(String(episodes))
                                    .foregroundStyle(Color.red)
                            }

                                                        
                            HStack{
                                NavigationLink(destination: AddRecensioneView(asyncManager: self.asyncManager)) {
                                    Text("Effettua una recensione")
                                        .foregroundStyle(Color.red)
                                }
                            }
                            
                            HStack{
                                Button("Aggiungi ai preferiti")
                                {
                                    Task{
                                        await self.asyncManager.addFavorites(token:self.asyncManager.token , idInfo:animeInfo._id)
                                        
                                        if(self.asyncManager.hasError){
                                            validationMessage = self.asyncManager.errorMessage
                                            showAlert.toggle()
                                        }
                                        else {
                                            validationMessage = self.asyncManager.requestMessage
                                            showAlert.toggle()
                                        }
                                    }
                                }
                                    .customButton()
                                    .alert(validationMessage, isPresented: $showAlert) {
                                        Button("OK", role: .cancel) {}
                                    }
                            }
                            
                            
                        } else {
                            Text("Nome sconosciuto")
                        }
                    }
        }
            .onAppear{
                Task{
                    await self.asyncManager.getAnimeByID(token: self.asyncManager.token, id: animeInfo._id)
                }
            }
        }
    }
}


