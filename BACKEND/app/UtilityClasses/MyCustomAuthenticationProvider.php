<?php

namespace App\UtilityClasses;

use App\Models\Profile;
use Tymon\JWTAuth\Contracts\Providers\Auth;
use Illuminate\Support\Facades\Auth as Autenticazione;

class MyCustomAuthenticationProvider implements Auth
{

    public function byCredentials(array $credentials = [])
    {
        //
    }

    public function byId($id)
    {
        $user = Profile::findByID($id);

        if(!$user)
            return false;

        Autenticazione::login($user);
        return true;

    }

    public function user()
    {
        return auth()->user();
    }
}
