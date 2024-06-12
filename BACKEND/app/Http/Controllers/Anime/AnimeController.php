<?php

namespace App\Http\Controllers\Anime;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Anime;

class AnimeController extends Controller
{
    public function getListaAnime(Request $request)
    {
        $limit = 10;
        $skip = $request->input('skip');

        if(!isset($skip))
            $skip = 1;
        $skip = (max($skip,1)-1)* $limit;

        $documents = Anime::findAllTitlePagination($limit,$skip);
        return response()->json(['animes' => $documents],200);
    }

    public function getAnime($id)
    {
        $document = Anime::getByID($id);
        return response()->json(['anime' => $document],200);
    }

    public function searchAnime(Request $request)
    {
        $limit = 10;
        $skip = $request->input('skip');

        if(!isset($skip))
            $skip = 1;
        $skip = (max($skip,1)-1)* $limit;

        $search = $request->input('search');

        $documents = Anime::findByTitlePagination($limit,$skip,$search);
        return response()->json(['animes' => $documents],200);
    }

    public function addFavouriteAnime(Request $request)
    {
        
        $id = $request->input('_id');

        $anime = Anime::findByID($id);

        if(!$anime)
        return response()->json(['message' => 'anime not found'],400);

        $user = Auth::user();

        $favanimes = $user->getFavoritesAnime();
        
        foreach($favanimes as $favanime)
        {
            if($favanime == intval($id))
                return response()->json(['message' => 'you can\'t bookmark this anime'],400);
        }
            
        
        $user->setFavoritesAnime(array_push($user->getFavoritesAnime(),$id));
        $user->updateDocument();
        return response()->json(['message' => 'anime added correctly'],200);
    }
    

    
}
