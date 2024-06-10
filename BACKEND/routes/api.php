<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\TestController;
use App\Http\Controllers\Auth\LoginController;


Route::get('/',[TestController::class,'helloWorld']);

Route::post('/token',[LoginController::class,'login']);
Route::get('/token/check',[LoginController::class,'check']);


