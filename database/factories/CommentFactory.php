<?php

namespace Database\Factories;

use App\Comment;
use Illuminate\Database\Eloquent\Factories\Factory;

class CommentFactory extends Factory
{
    protected $model = Comment::class;

    public function definition()
    {
        return [
            'subject' => rtrim($this->faker->sentence($this->faker->numberBetween(1, 4)), '.'),
            'body' => $this->faker->text($this->faker->numberBetween(10, 500)),
            'created_at' => $timestamp = $this->faker->dateTime,
            'updated_at' => $timestamp,
        ];
    }
}

