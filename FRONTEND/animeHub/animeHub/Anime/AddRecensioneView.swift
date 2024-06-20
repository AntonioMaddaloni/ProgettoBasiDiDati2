//
//  AddRecensioneView.swift
//  animeHub
//
//  Created by Antonio De Lucia on 18/06/24.
//

import SwiftUI

struct AddRecensioneView: View {
    
    @ObservedObject var asyncManager = ManagerViewModel()
    
    @State var overall: Int = 1
    @State var story: Int = 1
    @State var animation: Int = 1
    @State var sound: Int = 1
    @State var character: Int = 1
    @State var enjoyment: Int = 1
    @State private var newReviewText = ""
    @State private var selectedNumber = 1
    let numbers = Array(1...10)
    @State var validationMessage : String = ""
    @State var showAlert : Bool = false
    
    var body: some View {
   

        Form {
            Section(header: Text("Recensione")) {
                TextField("Inserisci nuova recensione", text: $newReviewText)
                
                Picker("Overall", selection: $overall) {
                    ForEach(numbers, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
                
                Picker("Story", selection: $story) {
                    ForEach(numbers, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
                
                Picker("Animation", selection: $animation) {
                    ForEach(numbers, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
                
                Picker("Sound", selection: $sound) {
                    ForEach(numbers, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
                
                Picker("Character", selection: $character) {
                    ForEach(numbers, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
                
                Picker("Enjoyment", selection: $enjoyment) {
                    ForEach(numbers, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
                
                VStack {
                    Button(action: {
                        var updatedScores = self.asyncManager.newScores
                        updatedScores.Animation = animation
                        updatedScores.Story = story
                        updatedScores.Character = character
                        updatedScores.Enjoyment = enjoyment
                        let floatOverall = Float(overall)
                        updatedScores.Overall = floatOverall
                        updatedScores.Sound = sound
                        Task {
                            await self.asyncManager.addReview(token: self.asyncManager.token, idInfo: self.asyncManager.singleAnime._id, testoRecensione: self.newReviewText, scores: updatedScores)

                            if(self.asyncManager.hasError) {
                                validationMessage="Recensione non effettuata"
                                showAlert.toggle()
                            } else {
                               
                                validationMessage="Recensione effettuata"
                                showAlert.toggle()
                            }
                        }
                    }) {
                        Text("Conferma")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .alert(validationMessage, isPresented: $showAlert) {
                        Button("OK", role: .cancel) {
                            Task{
                                await self.asyncManager.getUserData(token: self.asyncManager.token)
                            }
                            RecensioniView()
                        }
                    }
                }
                .padding()
            }
        }
        .padding()
    }
}


