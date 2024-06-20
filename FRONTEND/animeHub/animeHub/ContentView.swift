//
//  ContentView.swift
//  animeHub
//
//  Created by Antonio De Lucia on 13/06/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var validationMessage = ""
    @State private var showAlert: Bool = false
    @State private var isLogged: Bool = false
    @State private var clickOnRegistred: Bool = false
    @State private var gender = "Male"
    @State var birthday: Date = Date.now
    
    @ObservedObject var manager = HttpAuth()
    @ObservedObject var asyncManager = ManagerViewModel()
    
    var body: some View {
        if(isLogged){
            TabUIView(manager: self.manager, asyncManager: self.asyncManager)
        }
        
        else if(clickOnRegistred)
        {
            VStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350, height: 300)
                    .padding(.top,-100)
                Form
                {
                    Section(header: Text("Le tue credenziali")
                        .foregroundColor(.white))
                    {
                        TextField("Username", text:self.$username)
                        SecureField("Password", text:self.$password)
                    }
                    Section(header: Text("i tuoi dati")
                        .foregroundColor(.white))
                    {
                        Menu {
                            Button(action: {
                                self.gender = "Male"
                            }) {
                                Text("Male")
                            }
                            Button(action: {
                                self.gender = "Female"
                            }) {
                                Text("Female")
                            }
                        } label: {
                            Label(
                                title: {
                                    HStack {
                                        Text("Selezione sesso:")
                                            .foregroundColor((Color(UIColor.systemGray)))
                                            Spacer()
                                        Text("\(gender)")
                                            .foregroundColor((Color(UIColor.systemRed)))
                                            .padding()
                                            .underline()
                                        
                                    }
                                    
                                },
                                icon: {}
                            )
                            
                        }
                            DatePicker(
                                "Data di nascita: ",
                                selection: $birthday,
                                displayedComponents: [.date]
                            )
                            .foregroundColor((Color(UIColor.systemGray)))
                        
                        .frame(width: 300, height: 40)
                    }
                    Section{
                        Button("Registrati"){
                            Task{
                                await self.asyncManager.registration(username: username, password: password, gender: gender, birthday: birthday)
                                if (self.asyncManager.hasError){
                                    validationMessage = self.asyncManager.requestMessage
                                    showAlert.toggle()
                                }
                                else {
                                    validationMessage = "Registrazione effettuata con successo"
                                    showAlert.toggle()
                                }
                            }
                        }
                        .customButton()
                        .listRowBackground(Color(UIColor.systemGroupedBackground))
                        .alert(validationMessage, isPresented: $showAlert) {
                            Button("OK", role: .cancel) {}
                        }
                        
                    }
                    
                }
                .scrollContentBackground(.hidden)
            }
            VStack
            {
                Text("Hai gia fatto una registrazione?")
                    .fontWeight(.semibold)
                    .listRowBackground(Color(UIColor.systemGroupedBackground))
                    .frame(maxWidth: .infinity, alignment: .center)
                Rectangle()
                    .frame(width: 280,height: 1)
                    .foregroundColor((Color(UIColor.systemRed)))
                    .listRowBackground(Color(UIColor.systemGroupedBackground))
                Button(action: {
                    
                    clickOnRegistred=false
                    
                })
                {
                    Text("Accedi")
                        .fontWeight(.semibold)
                        .underline()
                        .listRowBackground(Color(UIColor.systemGroupedBackground))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                }
            }
        }
       else if !(clickOnRegistred){
            VStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350, height: 300)
                Form
                {
                    Section(header: Text("Le tue credenziali")
                        .foregroundColor(.white))
                    {
                        TextField("Username", text:self.$username)
                        SecureField("Password", text:self.$password)
                    }
                    Section{
                        Button("Accedi"){
                            Task{
                                await self.asyncManager.login(username:username, password:password)
                                if(self.asyncManager.hasError){
                                    validationMessage=self.asyncManager.requestMessage
                                    showAlert.toggle()
                                }
                                else
                                {
                                    self.manager.token = self.asyncManager.token
                                    self.isLogged = true
                                }
                            }
                        }
                        .customButton()
                        .listRowBackground(Color(UIColor.systemGroupedBackground))
                        .alert(validationMessage, isPresented: $showAlert) {
                            Button("OK", role: .cancel) {}
                        }
                        
                    }
                    
                }
                .scrollContentBackground(.hidden)
                
                VStack
                {
                    Text("Non hai mai fatto un accesso?")
                        .fontWeight(.semibold)
                        .listRowBackground(Color(UIColor.systemGroupedBackground))
                        .frame(maxWidth: .infinity, alignment: .center)
                    Rectangle()
                        .frame(width: 280,height: 1)
                        .foregroundColor((Color(UIColor.systemRed)))
                        .listRowBackground(Color(UIColor.systemGroupedBackground))
                    Button(action: {
                        
                        clickOnRegistred=true
                        
                    })
                    {
                        Text("Registrati")
                            .fontWeight(.semibold)
                            .underline()
                            .listRowBackground(Color(UIColor.systemGroupedBackground))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.white)
                    }
                }
                
                .padding(.top,-130)
                
                
                
            }
        }
    }
}

#Preview {
    ContentView()
}
