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

    

}
