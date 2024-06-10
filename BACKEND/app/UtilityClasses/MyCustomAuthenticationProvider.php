<?php

namespace App\UtilityClasses;

use Tymon\JWTAuth\Contracts\Providers\Auth;

class MyCustomAuthenticationProvider implements Auth
{
    public function byCredentials(array $credentials = [])
    {
        return true;
    }

    public function byId($id)
    {
        // maybe throw an expection?
    }

    public function user()
    {
        // you will have to implement this maybe.
    }
}
