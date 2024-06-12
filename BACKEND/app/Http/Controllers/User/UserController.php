<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;


class UserController extends Controller
{
    public function me()
    {
        $user = Auth::user();
        $data = [
                '_id' => $user->getKey(),
                'gender' => $user->getGender(),
                'birthday' => $user->getBirthday(),
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
