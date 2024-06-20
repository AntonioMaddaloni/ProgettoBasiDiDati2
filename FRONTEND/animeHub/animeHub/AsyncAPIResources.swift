//
//  AsyncAPIResources.swift
//  animeHub
//
//  Created by Antonio De Lucia on 13/06/24.
//

import Foundation


enum APIError: Error{
    case invalidUrl, requestError, decodingError, statusNotOk, serializationError
}

let BASE_URL: String = "http://127.0.0.1:8000/api"


struct AsyncApiServices{
    
    func login(username: String, password: String) async throws -> LoginResponse{
        guard let url = URL(string:  "\(BASE_URL)/token") else{
            throw APIError.invalidUrl
        }
        let body: [String: String] = ["username": username, "password": password]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) else{
            throw APIError.requestError
        }
        
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw APIError.statusNotOk
        }
        guard let result = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
            throw APIError.decodingError
        }
        
        return result
    }
    
    func registration(username: String, password: String, gender: String, birthday: Date) async throws -> RegistrationResponse{
        guard let url = URL(string:  "\(BASE_URL)/registrazione") else{
            throw APIError.invalidUrl
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/mm/yyyy"
        let body: [String: String] = ["username": username, "password": password, "gender": gender, "birthday": dateFormatter.string(from:birthday)]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) else{
            throw APIError.requestError
        }
        
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw APIError.statusNotOk
        }
 
        guard let result = try? JSONDecoder().decode(RegistrationResponse.self, from: data) else {
            throw APIError.decodingError
        }
        
        return result
    }
    
    func getUserData(token:String) async throws -> UserDataResponse{
        guard let url = URL(string:  "\(BASE_URL)/user/me") else{
            throw APIError.invalidUrl
        }
        
        let finalToken = "Bearer "+token
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(finalToken, forHTTPHeaderField: "Authorization")
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) else{
            throw APIError.requestError
        }
        
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw APIError.statusNotOk
        }
        guard let result = try? JSONDecoder().decode(UserDataResponse.self, from: data) else {
            throw APIError.decodingError
        }
        
        return result
    }
    
    func removeReview(token: String, _id: Int) async throws -> RemoveReviewResponse{
        guard let url = URL(string:  "\(BASE_URL)/review") else{
            throw APIError.invalidUrl
        }
        
        let body: [String: Int] = ["_id": _id]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        let finalToken = "Bearer "+token
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(finalToken, forHTTPHeaderField: "Authorization")
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) else{
            throw APIError.requestError
        }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw APIError.statusNotOk
        }
        
        guard let result = try? JSONDecoder().decode(RemoveReviewResponse.self, from: data) else {
            throw APIError.decodingError
        }
        
        return result
    }
    
    func updateReview(token: String, _id: Int, testoRecensione: String, scores: Scores) async throws -> UpdateReviewResponse {
        guard let url = URL(string: "\(BASE_URL)/review") else {
            throw APIError.invalidUrl
        }
        
        // Convertire l'oggetto Scores in un dizionario utilizzabile nel corpo della richiesta
        let scoresDict: [String: Any] = [
            "Overall": scores.Overall,
            "Story": scores.Story,
            "Animation": scores.Animation,
            "Sound": scores.Sound,
            "Character": scores.Character,
            "Enjoyment": scores.Enjoyment
        ]
        
        // Preparare il body della richiesta
        let body: [String: Any] = [
            "_id": _id,
            "testoRecensione": testoRecensione,
            "scores": scoresDict // Inserire il dizionario dei punteggi qui
        ]
        // Convertire il body in dati JSON
        guard let finalBody = try? JSONSerialization.data(withJSONObject: body) else {
            throw APIError.serializationError
        }
        
        // Preparare l'header Authorization con il token
        let finalToken = "Bearer " + token
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(finalToken, forHTTPHeaderField: "Authorization")
        
        do {
            // Eseguire la richiesta HTTP in modo asincrono
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestError
            }
            
            // Verificare se la risposta ha uno status code 200 OK
            guard httpResponse.statusCode == 200 else {
                throw APIError.statusNotOk
            }
            // Decodificare la risposta JSON in un oggetto UpdateReviewResponse
            let result = try JSONDecoder().decode(UpdateReviewResponse.self, from: data)
            return result
            
        } catch {
            throw error
        }
    }
    
    func getFavoritesAnime(token:String) async throws -> FavoritesResponse{
        guard let url = URL(string:  "\(BASE_URL)/user/my-favorites") else{
            throw APIError.invalidUrl
        }
        let finalToken = "Bearer "+token
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(finalToken, forHTTPHeaderField: "Authorization")
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) else{
            throw APIError.requestError
        }
        
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw APIError.statusNotOk
        }
        guard let result = try? JSONDecoder().decode(FavoritesResponse.self, from: data) else {
            throw APIError.decodingError
        }
        return result
    }
    
    func getAnime(token:String, skip:Int) async throws -> Animes{
        guard let url = URL(string:  "\(BASE_URL)/anime?skip=\(skip)") else{
            throw APIError.invalidUrl
        }
        let finalToken = "Bearer "+token
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(finalToken, forHTTPHeaderField: "Authorization")
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) else{
            throw APIError.requestError
        }
        
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw APIError.statusNotOk
        }
        guard let result = try? JSONDecoder().decode(Animes.self, from: data) else {
            throw APIError.decodingError
        }
        return result
    }

    
    func getAnimeByID(token:String, id:Int) async throws -> Anime{
        guard let url = URL(string:  "\(BASE_URL)/anime/id/\(id)") else{
            throw APIError.invalidUrl
        }
        let finalToken = "Bearer "+token
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(finalToken, forHTTPHeaderField: "Authorization")
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) else{
            throw APIError.requestError
        }
        
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw APIError.statusNotOk
        }
        guard let result = try? JSONDecoder().decode(Anime.self, from: data) else {
            throw APIError.decodingError
        }
        return result
    }
    

    func addReview(token: String, _id: Int, testoRecensione: String, scores: Scores) async throws -> AddReviewResponse {
        guard let url = URL(string: "\(BASE_URL)/review") else {
            throw APIError.invalidUrl
        }
        
        // Convertire l'oggetto Scores in un dizionario utilizzabile nel corpo della richiesta
        let scoresDict: [String: Any] = [
            "Overall": scores.Overall,
            "Story": scores.Story,
            "Animation": scores.Animation,
            "Sound": scores.Sound,
            "Character": scores.Character,
            "Enjoyment": scores.Enjoyment
        ]
        
        // Preparare il body della richiesta
        let body: [String: Any] = [
            "_id": _id,
            "testoRecensione": testoRecensione,
            "scores": scoresDict // Inserire il dizionario dei punteggi qui
        ]
        // Convertire il body in dati JSON
        guard let finalBody = try? JSONSerialization.data(withJSONObject: body) else {
            throw APIError.serializationError
        }
        
        // Preparare l'header Authorization con il token
        let finalToken = "Bearer " + token
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(finalToken, forHTTPHeaderField: "Authorization")
        
        do {
            // Eseguire la richiesta HTTP in modo asincrono
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestError
            }
            
            // Verificare se la risposta ha uno status code 200 OK
            guard httpResponse.statusCode == 200 else {
                throw APIError.statusNotOk
            }
            // Decodificare la risposta JSON in un oggetto UpdateReviewResponse
            let result = try JSONDecoder().decode(AddReviewResponse.self, from: data)
            return result
            
        } catch {
            throw error
        }
    }

    
    func searchAnime(token: String, search: String, skip: Int) async throws -> Animes{
        guard let url = URL(string:  "\(BASE_URL)/anime/search?skip=\(skip)") else{
            throw APIError.invalidUrl
        }
        let finalToken = "Bearer " + token
        let body: [String: String] = ["search": search]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(finalToken, forHTTPHeaderField: "Authorization")
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) else{
            throw APIError.requestError
        }
        
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw APIError.statusNotOk
        }
        guard let result = try? JSONDecoder().decode(Animes.self, from: data) else {
            throw APIError.decodingError
        }
        
        return result
    }
    
    func addFavorites(token: String, _id: Int) async throws -> AddFavoritesResponse{
        guard let url = URL(string:  "\(BASE_URL)/anime/add-favorite") else{
            throw APIError.invalidUrl
        }
        let finalToken = "Bearer " + token
        let body: [String: Int] = ["_id": _id]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(finalToken, forHTTPHeaderField: "Authorization")
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) else{
            throw APIError.requestError
        }
        
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw APIError.statusNotOk
        }
        guard let result = try? JSONDecoder().decode(AddFavoritesResponse.self, from: data) else {
            throw APIError.decodingError
        }
        
        return result
    }
    
}



@MainActor
class ManagerViewModel: ObservableObject {
    
    @Published var token: String = ""
    
    @Published var requestMessage: String = ""
    @Published var errorMessage = ""
    @Published var message = ""
    @Published var hasError = false
    
    @Published var authenticated = false
    
    
    @Published var gender: String = ""
    @Published var _id: String = ""
    @Published var _idRecensione: Int = 1
    @Published var birthday : String = ""
    @Published var text : String = ""
    @Published var reviewtList: [review] = [review]()
    @Published var scores: [Scores] = [Scores]()
    @Published var newScores : Scores = Scores(Overall: 0, Story: 0, Animation: 0, Sound: 0, Character: 0, Enjoyment: 0)
    @Published var idAnime: String = ""
    @Published var favoriteList: [String] = [String]()
    @Published var listAnime : [anime] = [anime]()
    @Published var skipPagine: Int = 1
    @Published var idInfo: Int = 0
    @Published var title: String = ""
    @Published var synopsis: String = ""
    @Published var gendre: [String] = [String]()
    @Published var aired: String = ""
    @Published var episodes : Double = 0
    @Published var popularity: Int = 0
    @Published var score : Double = 0
    @Published var imgUrl: String = ""
    @Published var singleAnime : anime = anime(_id: 0, title: "")
    @Published var search: String = ""
    
    func login(username: String, password: String) async{
        guard let data = try?  await  AsyncApiServices().login(username: username, password: password) else {
            self.token = ""
            self.hasError = true
            self.errorMessage  = "Server Error"
            self.requestMessage = "Username o/e password inserite non corrette"
            return
        }
        self.hasError = false
        self.token = data.token!
        self.authenticated = true
    }
    
    func registration(username: String, password: String, gender: String, birthday: Date) async{
        guard let data = try?  await  AsyncApiServices().registration(username: username, password: password, gender: gender, birthday: birthday ) else {
            self.token = ""
            self.hasError = true
            self.errorMessage  = "Server Error"
            self.requestMessage = "Username o/e password inserite non corrette"
            return
        }
        self.hasError = false
        self.token = data.token!
    }
    
    func getUserData(token: String) async{
        guard let data = try?  await  AsyncApiServices().getUserData(token: token) else {
            self.hasError = true
            self.errorMessage  = "Errore nel recupero dei dati utente"
            return
        }
        self._id = data._id!
        self.gender = data.gender!
        self.birthday = data.birthday!
        self.reviewtList = data.reviews
        
        
    }
    
    func removeReview(token: String, _idRecensione: Int) async{
        guard let data = try?  await  AsyncApiServices().removeReview(token: token, _id: _idRecensione) else {
            self.hasError = true
            self.errorMessage  = "Errore nel recupero dei dati utente"
            return
        }

        self.hasError = false;
        
    }
    
    func updateReview(token: String, _idRecensione: Int, testoRecensione: String, scores: Scores) async{
        guard let data = try?  await  AsyncApiServices().updateReview(token: token, _id: _idRecensione, testoRecensione: testoRecensione, scores: scores) else {
            self.hasError = true
            self.errorMessage  = "Errore nel recupero dei dati utente"
            return
        }
        self.hasError = false;
        
        
    }

    
    func getFavoritesAnime(token: String) async{
        guard let data = try?  await  AsyncApiServices().getFavoritesAnime(token: token) else {
            self.hasError = true
            self.errorMessage  = "Errore nel recupero degli anime preferiti"
            return
        }
        
        self.idAnime = data._id!
        self.favoriteList = data.favorites_anime
        
    }
    
    func getAnime(token: String, skip: Int) async{
        guard let data = try?  await  AsyncApiServices().getAnime(token: token, skip: skip) else {
            self.hasError = true
            self.errorMessage  = "Errore nel recupero degli anime preferiti"
            return
        }
        self.listAnime = data.animes
        self.skipPagine = skip
    }
    
    func getAnimeByID(token: String, id: Int) async{
        guard let data = try?  await  AsyncApiServices().getAnimeByID(token: token, id: id ) else {
            self.hasError = true
            self.errorMessage  = "Errore nel recupero degli anime preferiti"
            return
        }
        self.singleAnime = data.anime
    }
    
    func addReview(token: String, idInfo: Int, testoRecensione: String, scores: Scores) async{
        guard let data = try?  await  AsyncApiServices().addReview(token: token, _id: idInfo, testoRecensione: testoRecensione, scores: scores) else {
            self.hasError = true
            self.errorMessage  = "Errore nel recupero dei dati utente"
            return
        }

        self.hasError = false;
        
        
    }

    func searchAnime(token: String, search: String, skip: Int) async{
        guard let data = try?  await  AsyncApiServices().searchAnime(token: token, search: search, skip: skip) else {
            self.hasError = true
            self.errorMessage  = "Errore nel recupero dei dati utente"
            return
        }

        self.listAnime = data.animes
        self.search = search
        self.skipPagine = skip
        
        
    }
    
    func addFavorites(token: String, idInfo: Int) async{
        guard let data = try?  await  AsyncApiServices().addFavorites(token: token, _id: idInfo) else {
            self.hasError = true
            self.errorMessage  = "Anime gia aggiunto alla lista dei preferiti"
            return
        }

        self.hasError = false;
        self.requestMessage = "Anime aggiunto alla lista dei preferiti"
        
        
    }


}
