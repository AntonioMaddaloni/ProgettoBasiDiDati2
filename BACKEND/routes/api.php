<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\TestController;
use App\Http\Controllers\Auth\TokenController;
use App\Http\Controllers\Auth\RegistrazioneController;
use App\Http\Controllers\Anime\AnimeController;

Route::get('/',[TestController::class,'helloWorld']);

Route::prefix('/token')->group(function () {
    Route::post('/',[TokenController::class,'login']);
    Route::get('/check',[TokenController::class,'check']);
    Route::get('/renew',[TokenController::class,'renew']);
});

Route::post('/registrazione',[RegistrazioneController::class,'registrazione']);


Route::prefix('/anime')->group(function () {
    Route::get('/',[AnimeController::class,'getListaAnime']);

});

