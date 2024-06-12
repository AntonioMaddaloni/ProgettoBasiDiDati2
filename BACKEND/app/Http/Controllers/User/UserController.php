<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
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
        $data = [
                '_id' => $user->getKey(),
                'favorites_anime' => $user->getFavoritesAnime()
        ];
        return response()->json($data,200);
    }
}
