<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Profile;
use Illuminate\Support\Facades\Hash;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;

class TokenController extends Controller
{
    public function login(Request $request)
    {
        $username = $request->input('username');
        $password = $request->input('password');

        if(!isset($username) && !isset($password))
            return response()->json(['message' => 'Username or Password incorrect'], 401);

        $profilo = Profile::findByID($username);

        if ($profilo) {
            try{
                if(Hash::check($password,$profilo->getPassword()))
                {
                    $token = JWTAuth::fromUser($profilo);
            
                    return response()->json(['token' => $token]);
                }
                else
                    return response()->json(['message' => 'Username or Password incorrect'], 401);
            }
            catch(\Exception $e)
            {
                if($password == $profilo->getPassword())
                {
                    $token = JWTAuth::fromUser($profilo);
            
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
            return response()->json(['message' => 'token_not_provided'], 400);
        }

        // Verifica la validità del token senza autenticare l'utente
        $payload = JWTAuth::setToken($token)->checkOrFail();

        return response()->json(['token_valid' => true], 200);
        } catch (TokenExpiredException $e) {
            return response()->json(['token_valid' => false], 200);
        } catch (TokenInvalidException $e) {
            return response()->json(['message' => 'token_invalid'], 401);
        } catch (JWTException $e) {
            return response()->json(['message' => 'token_absent'], 401);
        }
    }

    public function renew(Request $request)
    {
        try {
        // Ottieni il token dall'header Authorization
        $token = $request->bearerToken();

        if (!$token) {
            return response()->json(['message' => 'token_not_provided'], 400);
        }

        // Verifica la validità del token senza autenticare l'utente
        $newToken = JWTAuth::setToken($token)->refresh();

        return response()->json(['token' => $newToken]);
        } catch (TokenExpiredException $e) {
            return response()->json(['message' => 'token_expired'], 401);
        } catch (TokenInvalidException $e) {
            return response()->json(['message' => 'token_invalid'], 401);
        } catch (JWTException $e) {
            return response()->json(['message' => 'token_absent'], 401);
        }
    }
}
