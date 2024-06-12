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





}
