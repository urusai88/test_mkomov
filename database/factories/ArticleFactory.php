<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use Illuminate\Support\Str;
use App\Article;
use Faker\Generator as Faker;

$factory->define(Article::class, function (Faker $faker) {
    return [
        'title' => $title = $faker->sentence($faker->numberBetween(1, 5)),
        'slug' => Str::slug($title),
        'body' => $faker->text,
        'created_at' => $dateTime = $faker->dateTime(),
        'updated_at' => $dateTime,
    ];
});
