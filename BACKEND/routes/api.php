<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\TestController;
use App\Http\Controllers\Auth\LoginController;


Route::get('/',[TestController::class,'helloWorld']);

Route::prefix('/token')->group(function () {
    Route::post('/',[LoginController::class,'login']);
    Route::get('/check',[LoginController::class,'check']);
    Route::get('/renew',[LoginController::class,'renew']);
});


