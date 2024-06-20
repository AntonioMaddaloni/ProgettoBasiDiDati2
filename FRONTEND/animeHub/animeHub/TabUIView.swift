//
//  TabUIView.swift
//  animeHub
//
//  Created by Antonio De Lucia on 14/06/24.
//

import SwiftUI

struct TabUIView: View {
    
    @ObservedObject var manager = HttpAuth()
    @ObservedObject var asyncManager = ManagerViewModel()
    
    
    var body: some View {
        
        TabView {
            AnimeView(asyncManager: self.asyncManager)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Anime")
                        .foregroundColor(.black)
                }
            ProfileView(asyncManager: self.asyncManager, manager: self.manager)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                        .foregroundColor(.black)
                }
            PreferitiView(asyncManager: self.asyncManager, manager: self.manager)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Preferiti")
                        .foregroundColor(.black)
                }
        }
        .accentColor( Color.red)

    }
}

#Preview {
    TabUIView()
}
