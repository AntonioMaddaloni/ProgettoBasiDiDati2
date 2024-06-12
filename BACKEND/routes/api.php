<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\TestController;
use App\Http\Controllers\Auth\TokenController;
use App\Http\Controllers\Auth\RegistrazioneController;
use App\Http\Controllers\Anime\AnimeController;
use App\Http\Controllers\User\UserController;

Route::get('/',[TestController::class,'helloWorld']);

Route::prefix('/token')->group(function () {
    Route::post('/',[TokenController::class,'login']);
    Route::get('/check',[TokenController::class,'check']);
    Route::get('/renew',[TokenController::class,'renew']);
});

Route::post('/registrazione',[RegistrazioneController::class,'registrazione']);


Route::middleware(['auth.jwt'])->group(function () {

    Route::prefix('/anime')->group(function () {
        Route::get('/',[AnimeController::class,'getListaAnime']);
        Route::get('/id/{id}',[AnimeController::class,'getAnime']);
        Route::post('/search',[AnimeController::class,'searchAnime']);
    });

    Route::prefix('/user')->group(function () {
        Route::get('/me',[UserController::class,'me']);
        Route::get('/my-favorites',[UserController::class,'myFavorites']);
    });

});

