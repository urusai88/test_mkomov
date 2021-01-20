<?php

use App\Http\Controllers\BlogController;
use Illuminate\Support\Facades\Route;

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

Route::group(['prefix' => 'blog'], function () {
    Route::get('/articles/{id}', [BlogController::class, 'article']);
    Route::get('/articles_last', [BlogController::class, 'articlesLast']);
    Route::get('/articles', [BlogController::class, 'articles']);
    Route::post('/articles/like', [BlogController::class, 'articleLike']);
    Route::post('/articles/unlike', [BlogController::class, 'articleUnlike']);
    Route::post('/articles/view', [BlogController::class, 'articleView']);

    Route::post('/comments/create', [BlogController::class, 'commentCreate']);
    Route::get('/comments/list/{id}', [BlogController::class, 'commentsList']);
});
