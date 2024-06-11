<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\TestController;
use App\Http\Controllers\Auth\TokenController;


Route::get('/',[TestController::class,'helloWorld']);

Route::prefix('/token')->group(function () {
    Route::post('/',[TokenController::class,'login']);
    Route::get('/check',[TokenController::class,'check']);
    Route::get('/renew',[TokenController::class,'renew']);
});

