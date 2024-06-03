<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class TestController extends Controller
{
    public function helloWorld(Request $request)
    {

        $database = app('mongodb');

        $data = [
            'databaseName' => $database->getDatabaseName()
        ];
        
        return response()->json($data);
    }
}
