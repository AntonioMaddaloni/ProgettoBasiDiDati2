<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Tymon\JWTAuth\Contracts\JWTSubject;

class Profile extends Model implements JWTSubject
{
    use HasFactory;

    private $_id;
    private $password;
    private $gender;
    private $birthday;
    private $favorites_anime;
    private $document;

    public function __construct() {
        $database = app('mongodb');
        $document = $database->profiles;
    }

    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims()
    {
        return [];
    }

    public function getKey()
    {
        return $this->_id;
    }

    public function setKey($_id)
    {
        $this->_id = $_id;
    }

    public function updateDocument()
    {
        $newValues = [
            '$set' => [
                '_id' => $this->_id,
                '$password' => $this->password,
                '$gender' => $this->gender,
                '$birthday' => $this->birthday,
                '$favorites_anime' => $this->favorites_anime
            ]
        ];

        $this->document->updateOne(['_id' => $this->_id], $newValues);
    }
}
