<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use App\Comment;
use Faker\Generator as Faker;

$factory->define(Comment::class, function (Faker $faker) {
    return [
        'subject' => rtrim($faker->sentence($faker->numberBetween(1, 4)), '.'),
        'body' => $faker->text($faker->numberBetween(10, 500)),
        'created_at' => $timestamp = $faker->dateTime,
        'updated_at' => $timestamp,
    ];
});
