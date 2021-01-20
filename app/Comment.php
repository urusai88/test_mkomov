<?php

namespace App;

use \DateTime;
use Illuminate\Database\Eloquent\Model;

/**
 * @property int $id
 * @property string $subject
 * @property string $body
 * @property int $article_id
 * @property DateTime $created_at
 * @property DateTime $updated_at
 */
class Comment extends Model
{
    protected $table = 'comments';
}
