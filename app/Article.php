<?php

namespace App;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * @property int $id
 * @property int $slug
 * @property int $views_count
 * @property int $likes_count
 */
class Article extends Model
{
    use HasFactory;

    protected $table = 'articles';

    public function articleTags()
    {
        return $this->belongsToMany(ArticleTag::class, 'articles_2_articles_tags', 'articles_id', 'articles_tags_id');
    }

    public function likes()
    {
        return $this->hasMany(ArticleLike::class, 'article_id');
    }

    public function like()
    {
        return $this->hasOne(ArticleLike::class, 'article_id');
    }

    public function comments()
    {
        return $this->hasMany(Comment::class, 'article_id');
    }
}
