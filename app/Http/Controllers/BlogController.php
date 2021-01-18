<?php

namespace App\Http\Controllers;

use App\Article;
use App\Comment;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Arr;

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

    public function articles()
    {
        /** @var LengthAwarePaginator $paginator */
        $paginator = Article::query()->paginate(10);
        $paginator->getCollection()->transform(function (Article $item) {
            $array = $item->toArray();
            $array['slug'] = "{$item->slug}.{$item->id}";

            return $array;
        });

        return $paginator;
    }
}
