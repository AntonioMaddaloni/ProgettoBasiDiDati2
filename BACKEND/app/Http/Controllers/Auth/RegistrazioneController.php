<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Profile;
use Carbon\Carbon;
use Tymon\JWTAuth\Facades\JWTAuth;

class RegistrazioneController extends Controller
{
    public function registrazione(Request $request)
    {
        $username = $request->input('username');
        $password = $request->input('password');
        $gender = $request->input('gender');
        $birthday = $request->input('birthday');

        if(!isset($username) && !isset($password) && !isset($gender) && !isset($birthday))
            return response()->json(['message' => 'Missing data'], 401);

        if($username == "" ||  $password == "")
            return response()->json(['message' => 'Missing data'], 401);

        $profilo = Profile::findByID($username);
        if($profilo){
            return response()->json(['message' => 'Already registered user'], 401);
        }

        if($gender != "Female" && $gender != "Male"){
            return response()->json(['message' => 'Gender not valid'], 401);
        }

        try
        {
            $carbonDate = Carbon::createFromFormat('d/m/Y', $birthday);
        }
        catch(\Exception $e) 
        {
            return response()->json(['message' => 'birthday not valid'], 401);
        }

        $formattedDate = $carbonDate->format('M d, Y');

        if($profilo=Profile::create($username, $password, $gender, $formattedDate)){
                $token = JWTAuth::fromUser($profilo);
                return response()->json(['token' => $token]);
        } 
        else 
        {
            return response()->json(['message' => 'registration not valid'], 500);
        }
    }
}
