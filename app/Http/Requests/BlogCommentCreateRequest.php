<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

/**
 * Class BlogCommentCreateRequest
 * @package App\Http\Requests
 * @property-read int $article_id
 * @property-read string $subject
 * @property-read string $body
 */
class BlogCommentCreateRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'article_id' => 'required|exists:articles,id',
            'subject' => 'required|string|min:1',
            'body' => 'required|string|min:1',
        ];
    }
}
