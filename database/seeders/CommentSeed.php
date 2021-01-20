<?php

namespace Database\Seeders;

use App\Article;
use App\Comment;
use Illuminate\Database\Seeder;

class CommentSeed extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $faker = \Faker\Factory::create();
        $articles = Article::query()->get();
        $articles->each(function (Article $article) use ($faker) {
            $comments = Comment::factory()->count($faker->numberBetween(0, 50))->make();

            $article->comments()->createMany($comments->toArray());
        });
    }
}
