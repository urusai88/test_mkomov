<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\BlogController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});

Route::group(['prefix' => 'blog'], function () {
    Route::get('/articles_last', [BlogController::class, 'articlesLast']);
    Route::get('/articles', [BlogController::class, 'articles']);
    Route::get('/article/{id}', [BlogController::class, 'getArticle']);
    Route::post('/comment/create', [BlogController::class, 'createComment']);
    Route::post('/articles/like', [BlogController::class, 'articleLike']);
    Route::post('/articles/unlike', [BlogController::class, 'articleUnlike']);
    Route::post('/articles/view', [BlogController::class, 'articleView']);
});
