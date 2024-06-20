//
//  PreferitiView.swift
//  animeHub
//
//  Created by Antonio De Lucia on 14/06/24.
//

import SwiftUI

struct PreferitiView: View {
    
    @ObservedObject var asyncManager = ManagerViewModel()
    @ObservedObject var manager = HttpAuth()
    @State private var stringValue: String = ""
    var body: some View
    {

        VStack
        {
            Text("ANIME PREFERITI")
                        .font(.title)
            List(self.asyncManager.favoriteList, id: \.self) { animeId in
                                   Text(String(animeId))
                                       .foregroundColor(.red)
                           }
        }
        .onAppear{
            Task{
                await self.asyncManager.getFavoritesAnime(token:self.asyncManager.token)
            }
            
        }
    }
}


#Preview {
    PreferitiView()
}
