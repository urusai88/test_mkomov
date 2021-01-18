<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Article;
use Faker\Generator as Faker;

$factory->define(Article::class, function (Faker $faker) {
    return [
        'body' => $faker->text,
        'created_at' => $dateTime = $faker->dateTime(),
        'updated_at' => $dateTime,
    ];
});
