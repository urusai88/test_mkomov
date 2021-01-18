<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * @property int $id
 */
class ArticleTag extends Model
{
    protected $table = 'articles_tags';
    public $timestamps = false;
}
