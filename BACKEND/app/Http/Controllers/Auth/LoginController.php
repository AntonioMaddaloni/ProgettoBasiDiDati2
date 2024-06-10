<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\Profile;
use Illuminate\Support\Facades\Hash;
use Illuminate\Http\Request;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;

class LoginController extends Controller
{
    public function login(Request $request)
    {
        $database = app('mongodb');

        $username = $request->input('username');
        $password = $request->input('password');

        $document = $database->profiles->findOne(['_id' => $username]);

        if ($document) {
            try{
                if(Hash::check($password,$document['password']))
                {
                    $profile = new Profile();
                    $profile->setKey($document['_id']);
                    $token = JWTAuth::fromUser($profile);
            
                    return response()->json(['token' => $token]);
                }
                else
                    return response()->json(['message' => 'Username or Password incorrect'], 401);
            }
            catch(\Exception $e)
            {
                if($password == $document['password'])
                {
                    $profile = new Profile();
                    $profile->setKey($document['_id']);
                    $token = JWTAuth::fromUser($profile);
            
                    return response()->json(['token' => $token]);
                }
                else
                    return response()->json(['message' => 'Username or Password incorrect'], 401);
            }
        } else {
            return response()->json(['message' => 'Username or Password incorrect'], 401);
        }

    }

    public function check(Request $request)
    {
        try {
        // Ottieni il token dall'header Authorization
        $token = $request->bearerToken();

        if (!$token) {
            return response()->json(['error' => 'token_not_provided'], 400);
        }

        // Verifica la validità del token senza autenticare l'utente
        $payload = JWTAuth::setToken($token)->checkOrFail();

        return response()->json(['token_valid' => true, 'payload' => $payload], 200);
        } catch (TokenExpiredException $e) {
            return response()->json(['error' => 'token_expired'], 401);
        } catch (TokenInvalidException $e) {
            return response()->json(['error' => 'token_invalid'], 401);
        } catch (JWTException $e) {
            return response()->json(['error' => 'token_absent'], 401);
        }
    }
}
