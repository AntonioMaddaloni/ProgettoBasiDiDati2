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
        return response()->json(['animes' => $documents]);
    }

    public function getAnime($id)
    {
        $document = Anime::getByID($id);
        return response()->json(['anime' => $document]);
    }

    
}
