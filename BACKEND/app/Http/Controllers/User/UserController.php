<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\Models\Anime;
use App\Models\Review;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;


class UserController extends Controller
{
    public function me()
    {
        $user = Auth::user();
        $reviews = Review::findAllReviewDocumentByProfile($user->getKey());
        $data = [
                '_id' => $user->getKey(),
                'gender' => $user->getGender(),
                'birthday' => $user->getBirthday(),
                'reviews' => $reviews
        ];

        return response()->json($data,200);
    }

    public function myFavorites()
    {
        $user = Auth::user();
        $animes = $user->getFavoritesAnime();
        $animesResponse = [];

        foreach($animes as $anime)
        {
            array_push($animesResponse,Anime::getByID($anime)['title']);
        }

        $data = [
                '_id' => $user->getKey(),
                'favorites_anime' => $animesResponse
        ];
        return response()->json($data,200);
    }
}
