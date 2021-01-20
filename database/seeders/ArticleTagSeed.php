<?php

namespace Database\Seeders;

use App\Article;
use App\ArticleTag;
use Illuminate\Database\Seeder;

class ArticleTagSeed extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $faker = \Faker\Factory::create();
        /** @var ArticleTag[]|\Illuminate\Database\Eloquent\Collection $articleTags */
        $articleTags = ArticleTag::factory()->count(10)->create();

        Article::query()->each(function (Article $item) use ($articleTags, $faker) {
            /** @var int[] $randomTagIdList */
            $randomTagIdList = $articleTags
                ->random($faker->numberBetween(1, $articleTags->count()))
                ->map(function (ArticleTag $articleTag) {
                    return $articleTag->id;
                });

            $item->articleTags()->attach($randomTagIdList);
        });
    }
}
