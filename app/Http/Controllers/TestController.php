<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class TestController extends Controller
{
    public function helloWorld(Request $request)
    {

        $data = [
            'message' => 'Hello World!'
        ];

        return response()->json($data);
    }
}
