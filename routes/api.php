<?php

use App\Http\Controllers\BlogController;
use Illuminate\Support\Facades\Route;

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
