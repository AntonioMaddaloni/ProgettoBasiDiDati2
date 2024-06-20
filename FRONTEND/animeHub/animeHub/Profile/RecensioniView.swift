//
//  RecensioniView.swift
//  animeHub
//
//  Created by Antonio De Lucia on 14/06/24.
//

import SwiftUI

struct RecensioniView: View {
    
    
    @ObservedObject var asyncManager = ManagerViewModel()
    @ObservedObject var manager = HttpAuth()
    @State private var clickOnEdit: Bool = false

    
    var body: some View {
        if(clickOnEdit){
            
        }
            ForEach(asyncManager.reviewtList, id: \.self) { review in
                Form {
                    Section(header: Text(String(review._id))) {
                        HStack{
                            Text("Testo")
                            Spacer()
                            Text(review.text)
                                .foregroundStyle(Color.red)
                        }
                        HStack{
                            Text("Voto")
                            Spacer()
                            Text(String(review.score))
                                .foregroundStyle(Color.red)
                        }
                        HStack{
                            Text("Overall")
                            Spacer()
                            Text(String(review.scores.Overall))
                                .foregroundStyle(Color.red)
                        }
                        HStack{
                            Text("Animation")
                            Spacer()
                            Text(String(review.scores.Animation))
                                .foregroundStyle(Color.red)
                        }
                        HStack{
                            Text("Character")
                            Spacer()
                            Text(String(review.scores.Character))
                                .foregroundStyle(Color.red)
                        }
                        HStack{
                            Text("Character")
                            Spacer()
                            Text(String(review.scores.Enjoyment))
                                .foregroundStyle(Color.red)
                        }
                        HStack{
                            Text("Story")
                            Spacer()
                            Text(String(review.scores.Story))
                                .foregroundStyle(Color.red)
                        }
                        HStack{
                            Text("Sound")
                            Spacer()
                            Text(String(review.scores.Sound))
                                .foregroundStyle(Color.red)
                        }
                        HStack{
                            Text("Enjoyment")
                            Spacer()
                            Text(String(review.scores.Enjoyment))
                                .foregroundStyle(Color.red)
                        }

                        NavigationLink(destination: EditReviewView(asyncManager: self.asyncManager, reviewEdit: review)) {
                            Text("Modifica")
                                .foregroundColor(.blue)
                        }

                            Button(action: {
                                Task{
                                    await self.asyncManager.removeReview(token: self.asyncManager.token, _idRecensione: review._id)
                                    await self.asyncManager.getUserData(token: self.asyncManager.token)
                                }

                            }) {
                                Text("Elimina")
                                    .foregroundColor(.red)
                            }
                        
                    }
                }
            }
            
        }
    }

#Preview {
    RecensioniView()
}
