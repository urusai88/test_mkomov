<?php

/** @var \Illuminate\Database\Eloquent\Factory $factory */

use Illuminate\Support\Str;
use App\ArticleTag;
use Faker\Generator as Faker;

$factory->define(ArticleTag::class, function (Faker $faker) {
    $label = $faker->sentence($faker->numberBetween(1, 3));

    return [
        'label' => $label,
        'url' => Str::slug($label),
    ];
});
