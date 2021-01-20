<?php

namespace Database\Seeders;

use App\Article;
use Illuminate\Database\Seeder;

class ArticleSeed extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Article::factory()->count(2)->create();
    }
}
