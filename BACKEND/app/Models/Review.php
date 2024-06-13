<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Review extends Model
{
    use HasFactory;

    private $_id;
    private $profile;
    private $anime;
    private $text;
    private $score;
    private $scores;
    private $document; 

    public function __construct() {
        $database = app('mongodb');
        $document = $database->animes;
    }

    public static function findAllReviewDocumentByProfile($profile)
    {
        $database = app('mongodb');
        $collezione = $database->reviews->find(['profile' => $profile]);
        $documentsParsed = iterator_to_array($collezione);
        $i = 0;
        foreach ($documentsParsed as $documento) {
            if (is_float($documento['text']) && is_nan($documento['text'])) {
                $documentsParsed[$i]['text'] = null;
            }
            if (is_float($documento['score']) && is_nan($documento['score'])) {
                $documentsParsed[$i]['score'] = null;
            }
            if (is_float($documento['scores']) && is_nan($documento['scores'])) {
                $documentsParsed[$i]['scores'] = null;
            }
            $i = $i+1;
        }
        return $documentsParsed;
    }

    public static function getByIDAndUser($_id,$profile)
    {
        $database = app('mongodb');
        $collezione = $database->reviews->findOne(['_id' => $_id, 'profile' => $profile]);
        
        if(!$collezione)
            return null;

        return $collezione;
    }

    public static function updateAll($id,$anime,$scores,$testoRecensione)
    {
        $database = app('mongodb');

        $values = array_values($scores);
        $sum = array_sum($values);
        $count = count($values);
        $average = $sum / $count;

        $database->reviews->updateOne(
            ['_id' => $id],
            ['$set' => ['score' => $average, 'scores' => $scores, 'text' => $testoRecensione]]
        );

        $animedocument = Anime::findByID($anime);
        $newscore = $animedocument->updateScore();
        return $newscore;

    }

    public static function deleteAll($id,$anime)
    {
        $database = app('mongodb');

        $result = $database->reviews->deleteOne(['_id' => $id]);

        $animedocument = Anime::findByID($anime);
        $newscore = $animedocument->updateScore();
        return $newscore;
    }


    public static function create($testoRecensione, $scores, $profile, $anime)
    {
        $database = app('mongodb');

        $values = array_values($scores);
        $sum = array_sum($values);
        $count = count($values);
        $average = $sum / $count;

        $maxIdDocument = $database->reviews->aggregate([['$group' => ['_id' => null, 'maxId' => ['$max' => '$_id']]] ])->toArray();
        $maxId = $maxIdDocument[0]->maxId +1;

        $newDocument = [
            '_id' => $maxId,
            'anime' => $anime,
            'profile' => $profile,
            'text' => $testoRecensione,
            'scores' => $scores,
            'score'=> $average
        ];
        

        $result = $database->reviews->insertOne($newDocument);
        
        if ($result->getInsertedCount() > 0) {
            return true;
        } else {
            return false;
        }

    }


}
