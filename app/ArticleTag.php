<?php

namespace App;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * @property int $id
 */
class ArticleTag extends Model
{
    use HasFactory;

    protected $table = 'articles_tags';
    public $timestamps = false;
}
