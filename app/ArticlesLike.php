<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class ArticlesLike extends Model
{
    protected $table = 'articles_likes';
    protected $primaryKey = ['article_id', 'ip_address'];

    public $incrementing = false;
    public $timestamps = false;
}
