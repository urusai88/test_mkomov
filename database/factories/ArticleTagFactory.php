<?php

namespace Database\Factories;

use App\ArticleTag;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

class ArticleTagFactory extends Factory
{
    protected $model = ArticleTag::class;

    public function definition()
    {
        $label = $this->faker->sentence($this->faker->numberBetween(1, 3));

        return [
            'label' => $label,
            'url' => Str::slug($label),
        ];
    }
}
