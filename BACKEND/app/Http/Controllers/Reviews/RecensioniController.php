<?php

namespace App\Http\Controllers\Reviews;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Anime;
use App\Models\Review;
use Illuminate\Support\Facades\Auth;

class RecensioniController extends Controller
{
    public function addRecensione(Request $request)
    {
        $id = $request->input('_id');
        $testoRecensione = $request->input('testoRecensione');
        $scores = $request->input('scores');
        $anime = Anime::findByID(intval($id));
        
        if(!$anime)
            return response()->json(['message' => 'anime not found'],400);
            
        $user = Auth::user();


       $recensione = Review::create($testoRecensione,$scores,$user->getKey(),$anime->getKey());
       
       if($recensione)
       {
        return response()->json(['message' => 'review succes'],200);
       }
       else
       {
        return response()->json(['message' => 'review failed'],500);
       }

       

    }
}
