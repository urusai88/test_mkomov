<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class Blog extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('articles', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->text('body');
            $blueprint->integer('likes_count')->default(0);
            $blueprint->integer('views_count')->default(0);
            $blueprint->timestamps();
        });

        Schema::create('comments', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->text('subject');
            $blueprint->text('body');
            $blueprint->integer('article_id');

            $blueprint->foreign('article_id')
                ->references('id')->on('articles')
                ->cascadeOnDelete()
                ->cascadeOnUpdate();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('comments');
        Schema::drop('articles');
    }
}
