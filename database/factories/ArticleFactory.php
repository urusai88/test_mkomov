<?php

namespace Database\Factories;

use App\Article;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

class ArticleFactory extends Factory
{
    protected $model = Article::class;

    public function definition()
    {
        return [
            'title' => $title = $this->faker->sentence($this->faker->numberBetween(1, 5)),
            'slug' => Str::slug($title),
            'body' => $this->faker->text,
            'created_at' => $dateTime = $this->faker->dateTime(),
            'updated_at' => $dateTime,
        ];
    }
}

