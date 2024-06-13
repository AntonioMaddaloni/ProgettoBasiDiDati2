<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use MongoDB\Client;
use MongoDB\BSON\Regex;

class Anime extends Model
{
    use HasFactory;

    private $_id;
    private $title;
    private $synopsis;
    private $genre;
    private $aired;
    private $episodes;
    private $popularity;
    private $score;
    private $img_url;
    private $document; 

    public function __construct() {
        $database = app('mongodb');
        $document = $database->animes;
    }

    public function getKey()
    {
        return $this->_id;
    }

    public static function findAllDocumentPagination($limit,$skip)
    {

        $database = app('mongodb');
        $collezione = $database->animes->find([],['limit' => $limit, 'skip' => $skip, 'sort' => ['title' => 1]]);
        $documentsParsed = iterator_to_array($collezione);
        $i = 0;
        foreach ($documentsParsed as $documento) {
            if (is_float($documento['title']) && is_nan($documento['title'])) {
                $documentsParsed[$i]['title'] = null;
            }
            if (is_float($documento['synopsis']) && is_nan($documento['synopsis'])) {
                $documentsParsed[$i]['synopsis'] = null;
            }
            if (is_float($documento['genre']) && is_nan($documento['genre'])) {
                $documentsParsed[$i]['genre'] = null;
            }
            if (is_float($documento['aired']) && is_nan($documento['aired'])) {
                $documentsParsed[$i]['aired'] = null;
            }
            if (is_float($documento['episodes']) && is_nan($documento['episodes'])) {
                $documentsParsed[$i]['episodes'] = null;
            }
            if (is_float($documento['popularity']) && is_nan($documento['popularity'])) {
                $documentsParsed[$i]['popularity'] = null;
            }
            if (is_float($documento['score']) && is_nan($documento['score'])) {
                $documentsParsed[$i]['score'] = null;
            }
            if (is_float($documento['img_url']) && is_nan($documento['img_url'])) {
                $documentsParsed[$i]['img_url'] = null;
            }
            $i = $i+1;
        }
        return $documentsParsed;
    }

    public static function findAllTitlePagination($limit,$skip)
    {

        $database = app('mongodb');
        $collezione = $database->animes->find([],['limit' => $limit, 'skip' => $skip, 'sort' => ['title' => 1],'projection' => ['title' => 1]]);
        $documentsParsed = iterator_to_array($collezione);
        $i = 0;
        foreach ($documentsParsed as $documento) {
            if (is_float($documento['title']) && is_nan($documento['title'])) {
                $documentsParsed[$i]['title'] = null;
            }
            $i = $i+1;
        }
        return $documentsParsed;
    }

    public static function findByTitlePagination($limit,$skip,$search)
    {

        $database = app('mongodb');
        $regex = new Regex($search, 'i');
        $collezione = $database->animes->find(['title' => $regex],['limit' => $limit, 'skip' => $skip, 'sort' => ['title' => 1],'projection' => ['title' => 1]]);
        $documentsParsed = iterator_to_array($collezione);
        $i = 0;
        foreach ($documentsParsed as $documento) {
            if (is_float($documento['title']) && is_nan($documento['title'])) {
                $documentsParsed[$i]['title'] = null;
            }
            $i = $i+1;
        }
        return $documentsParsed;
    }

    public static function findByID($_id)
    {
        $database = app('mongodb');
        $documento = $database->animes->findOne(['_id' => intval($_id)]);

        if(!$documento)
            return null;
        
        $anime = new Anime();
        $anime->_id = $documento['_id'];
        $anime->title = $documento['title']; 
        $anime->synopsis = $documento['synopsis']; 
        $anime->genre = $documento['genre']; 
        $anime->aired = $documento['aired'];
        $anime->episodes = $documento['episodes'];
        $anime->popularity = $documento['popularity'];
        $anime->score = $documento['score'];
        $anime->img_url = $documento['img_url'];
        $anime->document = $database->animes;
        return $anime;
    }

    public static function getByID($id)
    {
        $database = app('mongodb');
        $documento = $database->animes->findOne(['_id' => intval($id)]);
        if(!$documento)
            return null;

        return $documento;
    }

    public function updateScore()
    {
        $database = app('mongodb');

        $result = $database->reviews->aggregate([
            [
                '$match' => [
                    'anime' => $this->_id
                ]
            ],
            [
                '$group' => [
                    '_id' => null,
                    'averageScore' => ['$avg' => '$score']
                ]
            ]
        ])->toArray();

        $averageScore = round($result[0]['averageScore'] ?? 0,2);

        $result = $this->document->updateOne(
            ['_id' => $this->_id],
            ['$set' => ['score' => $averageScore]]
        );

        if ($result->getModifiedCount() > 0) {
            return $averageScore;
        } else {
            return null;
        }

    }

    

}
