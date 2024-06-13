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
        $id = $request->input('_id'); //Dell'Anime non Della Review
        $testoRecensione = $request->input('testoRecensione');
        $scores = $request->input('scores');
        $anime = Anime::findByID(intval($id));
        
        if(!$anime)
            return response()->json(['message' => 'anime not found'],400);
            
        $user = Auth::user();


       $recensione = Review::create($testoRecensione,$scores,$user->getKey(),$anime->getKey());

       if($recensione)
       {
            $newscore = $anime->updateScore();

            if(isset($newscore))
                return response()->json(['score' => $newscore],200);
            else
                return response()->json(['message' => 'review failed'],500);
       }
       else
       {
            return response()->json(['message' => 'review failed'],500);
       }

       

    }

    public function editRecensione(Request $request)
    {
        $id = $request->input('_id');
        $testoRecensione = $request->input('testoRecensione');
        $scores = $request->input('scores');
        $user = Auth::user();
        $review = Review::getByIDAndUser(intval($id),$user->getKey());
        
        if(!$review)
            return response()->json(['message' => 'review not found'],400);

       $newscore = Review::updateAll($id,$review['anime'],$scores,$testoRecensione);

       if($newscore)
            return response()->json(['score' => $newscore],200);
       else
            return response()->json(['message' => 'review failed'],500);

    }

    public function deleteRecensione(Request $request)
    {
        $id = $request->input('_id');
        $user = Auth::user();
        $review = Review::getByIDAndUser(intval($id),$user->getKey());
        
        if(!$review)
            return response()->json(['message' => 'review not found'],400);

       $newscore = Review::deleteAll($id,$review['anime']);

       if($newscore)
            return response()->json(['score' => $newscore],200);
       else
            return response()->json(['message' => 'review failed'],500);

    }
}
