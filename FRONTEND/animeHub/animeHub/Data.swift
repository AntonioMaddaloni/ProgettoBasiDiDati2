//
//  Data.swift
//  animeHub
//
//  Created by Antonio De Lucia on 13/06/24.
//

import Foundation
import SwiftUI
import Combine
import UIKit

extension View {
    func customButton() -> ModifiedContent<Self, ButtonModifier> {
        return modifier(ButtonModifier())
    }
}

class HttpAuth: ObservableObject {
    
    @Published var token = ""
    @Published var message = ""
    @Published var errors = ""
}

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.headline)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color(UIColor.systemRed)))
            .padding(.bottom)
    }
}


struct LoginResponse: Decodable{
    var token: String?
    var message: String?
}

struct RegistrationResponse: Decodable{
    var token: String?
    var message: String?
}

struct Scores: Codable, Hashable{
    var Overall: Float
    var Story: Int
    var Animation: Int
    var Sound: Int
    var Character : Int
    var Enjoyment : Int
        
}

struct review : Decodable, Hashable {
    var _id: Int
    var anime : Int
    var profile : String
    var text : String
    var scores : Scores
    var score : Float
    
}

struct UserDataResponse : Decodable{
    var _id : String?
    var gender : String?
    var birthday : String?
    var reviews: [review]
}

struct RemoveReviewResponse : Decodable {
    var message: String?
    var score: Int?
}
struct UpdateReviewResponse : Decodable {
    var score : Float?
    var message : String?
}

struct FavoritesResponse : Decodable{
    var _id : String?
    var favorites_anime: [String]
    
}

struct Animes : Decodable {
    var animes: [anime]
}

struct anime : Decodable, Hashable{
    var _id: Int
    var title: String
    var synopsis: String?
    var genre: [String]?
    var aired: String?
    var episodes: Double?
    var popularity: Int?
    var score: Double?
    var img_url: String?
}

struct Anime : Decodable{
    var anime : anime
}

struct AddReviewResponse : Decodable 
{
    var score : Float?
    var messagge : String?
}

struct AddFavoritesResponse : Decodable 
{
    var message : String?
}
