<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * @property int $id
 * @property int $slug
 */
class Article extends Model
{
    protected $table = 'articles';

    public function articleTags()
    {
        return $this->belongsToMany(ArticleTag::class, 'articles_2_articles_tags', 'articles_id', 'articles_tags_id');
    }
}
