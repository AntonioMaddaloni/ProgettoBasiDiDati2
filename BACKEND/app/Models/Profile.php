<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Tymon\JWTAuth\Contracts\JWTSubject;
use Illuminate\Support\Facades\Hash;
use MongoDB\Client;

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

    public function getPassword()
    {
        return $this->password;
    }

    public function setPassword($password)
    {
        $this->$password = $password;
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

    public static function findByID($_id)
    {
        $database = app('mongodb');
        $documento = $database->profiles->findOne(['_id' => $_id]);

        if(!$documento)
            return null;
        
        $profilo = new Profile();
        $profilo->_id = $documento['_id'];
        $profilo->password = $documento['password']; 
        $profilo->gender = $documento['gender']; 
        $profilo->birthday = $documento['birthday']; 
        $profilo->favorites_anime = $documento['favorites_anime'];
        return $profilo;
    }

    public static function create($username, $password, $gender, $birthday)
    {
        $database = app('mongodb');
        $password= Hash::make($password);
        $newDocument = [
            '_id' => $username,
            'password' => $password,
            'gender' => $gender,
            'birthday'=> $birthday,
            'favorites_anime' => []
        ];
        


        $result = $database->profiles->insertOne($newDocument);
        
        if ($result->getInsertedCount() > 0) {
            return Profile::findByID($username);
        } else {
            return null;
        }

    }
}
