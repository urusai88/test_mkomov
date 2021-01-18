<?php

use Illuminate\Database\Seeder;

use App\Article;
use App\Comment;

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
            $comments = factory(Comment::class, $faker->numberBetween(0, 50))->make();

            $article->comments()->createMany($comments->toArray());
        });
    }
}
