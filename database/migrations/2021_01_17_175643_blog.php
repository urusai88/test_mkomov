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
            $blueprint->text('title');
            $blueprint->text('body');
            $blueprint->text('slug');
            $blueprint->integer('likes_count')->default(0);
            $blueprint->integer('views_count')->default(0);
            $blueprint->timestamps();
        });

        Schema::create('articles_tags', function (Blueprint $blueprint) {
            $blueprint->id();
            $blueprint->string('url')->unique();
            $blueprint->string('label')->unique();
        });

        Schema::create('articles_2_articles_tags', function (Blueprint $blueprint) {
            $blueprint->bigInteger('articles_id');
            $blueprint->bigInteger('articles_tags_id');

            $blueprint->primary(['articles_id', 'articles_tags_id']);
            $blueprint->foreign('articles_id')->references('id')->on('articles')
                ->cascadeOnDelete()
                ->cascadeOnUpdate();
            $blueprint->foreign('articles_tags_id')->references('id')->on('articles_tags')
                ->cascadeOnDelete()
                ->cascadeOnUpdate();
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

        Schema::create('articles_likes', function (Blueprint $blueprint) {
            $blueprint->bigInteger('article_id');
            $blueprint->ipAddress('ip_address');

            $blueprint->primary(['article_id', 'ip_address']);
            $blueprint->foreign('article_id')->references('id')->on('articles')
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
        Schema::drop('articles_likes');
        Schema::drop('comments');
        Schema::drop('articles_2_articles_tags');
        Schema::drop('articles_tags');
        Schema::drop('articles');
    }
}
