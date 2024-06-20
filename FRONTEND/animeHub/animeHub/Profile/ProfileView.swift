//
//  ProfileView.swift
//  animeHub
//
//  Created by Antonio De Lucia on 14/06/24.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var asyncManager = ManagerViewModel()
    @ObservedObject var manager = HttpAuth()
    
    
    
    var body: some View {
    NavigationView{
        VStack{
            Form{
                Section("Dati"){
                    HStack{
                        Text("Username")
                        Spacer()
                        Text(self.asyncManager._id)
                            .foregroundStyle(Color.red)
                    }
                    HStack{
                        Text("Sesso")
                        Spacer()
                        Text(self.asyncManager.gender)
                            .foregroundStyle(Color.red)
                    }
                    HStack{
                        Text("Data di nascita")
                        Spacer()
                        Text(self.asyncManager.birthday)
                            .foregroundStyle(Color.red)
                    }
                    NavigationLink(destination: RecensioniView(asyncManager: self.asyncManager)) {
                        Text("Recensioni")
                            .foregroundStyle(Color.white)
                    }
                }
            }
            .onAppear{
                Task{
                    await self.asyncManager.getUserData(token:self.asyncManager.token)
                }
            }
        }
    }
    }
}

#Preview {
    ProfileView()
}



