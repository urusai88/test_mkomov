<?php

namespace App\Http\Controllers;

use App\Article;
use App\Comment;
use Illuminate\Http\Request;

class BlogController extends Controller
{
    /**
     * @param Request $request
     * @return Comment
     * @throws \Throwable
     */
    public function createComment(Request $request)
    {
        $data = $request->validate([
            'article_id' => 'required|exists:articles',
            'subject' => 'required|string|min:1',
            'body' => 'required|string|min:1',
        ]);

        /** @var Comment $comment */
        $comment = Comment::unguarded(function () use ($data) {
            return new Comment($data);
        });
        $comment->saveOrFail();

        return $comment;
    }

    public function articlesLast()
    {
        return Article::query()->limit(6)->get();
    }
}
