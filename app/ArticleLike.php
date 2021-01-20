<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * @property int $article_id
 * @property string $ip_address
 */
class ArticleLike extends Model
{
    protected $table = 'articles_likes';
    protected $primaryKey = ['article_id', 'ip_address'];

    public $incrementing = false;
    public $timestamps = false;
}
