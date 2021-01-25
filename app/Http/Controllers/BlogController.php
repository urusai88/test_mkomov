<?php

namespace App\Http\Controllers;

use App\Article;
use App\ArticleLike;
use App\Comment;
use App\Http\Requests\BlogCommentCreateRequest;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;

class BlogController extends Controller
{
    protected function articleWithLike($ipAddress)
    {
        return [
            'like as like' => function (Builder $query) use ($ipAddress) {
                $query->where('ip_address', $ipAddress);
            },
        ];
    }

    protected function articleIdValidator()
    {
        return [
            'article_id' => 'required|exists:articles,id',
        ];
    }

    public function commentCreate(BlogCommentCreateRequest $request)
    {
        $request->validated();

        $comment = new Comment();
        $comment->article_id = $request->article_id;
        $comment->subject = $request->subject;
        $comment->body = $request->body;
        $comment->saveOrFail();

        return $comment;
    }

    public function commentsList($id)
    {
        /** @var Article $article */
        $article = Article::query()->findOrFail($id);

        return $article->comments()
            ->orderByDesc('created_at')
            ->paginate(10);
    }

    public function articlesLast(Request $request)
    {
        return Article::query()
            ->withCount($this->articleWithLike($request->ip()))
            ->with('articleTags')
            ->orderByDesc('created_at')
            ->limit(6)
            ->get();
    }

    public function articles(Request $request)
    {
        return Article::query()
            ->withCount($this->articleWithLike($request->ip()))
            ->with('articleTags')
            ->orderByDesc('created_at')
            ->paginate(10);
    }

    public function article($id, Request $request)
    {
        return Article::query()
            ->withCount($this->articleWithLike($request->ip()))
            ->with('articleTags')
            ->findOrFail($id);
    }

    public function articleView(Request $request)
    {
        $data = $request->validate($this->articleIdValidator());
        $id = $data['article_id'];

        $query = Article::query()->whereKey($id);
        $query->increment('views_count');

        return [
            'views_count' => $query->pluck('views_count')->first(),
        ];
    }

    protected function likeExists($id, $ip)
    {
        return ArticleLike::query()
            ->where('article_id', $id)
            ->where('ip_address', $ip)
            ->exists();
    }

    public function articleLike(Request $request)
    {
        $data = $request->validate($this->articleIdValidator());
        $id = $data['article_id'];
        $ip = $request->ip();

        $exists = $this->likeExists($id, $ip);

        if (!$exists) {
            $articleLike = new ArticleLike();
            $articleLike->article_id = $id;
            $articleLike->ip_address = $ip;
            $articleLike->save();

            Article::query()->whereKey($id)->increment('likes_count');
        }

        return [
            'id' => $id,
            'likes_count' => Article::query()->whereKey($id)->pluck('likes_count')->first(),
            'status' => true,
        ];
    }

    public function articleUnlike(Request $request)
    {
        $data = $request->validate($this->articleIdValidator());
        $id = $data['article_id'];
        $ip = $request->ip();

        $exists = $this->likeExists($id, $ip);

        if ($exists) {
            $deleted = ArticleLike::query()
                ->where('article_id', $id)
                ->where('ip_address', $ip)
                ->delete();

            if ($deleted) {
                Article::query()->whereKey($id)->decrement('likes_count');
            }
        }

        return [
            'id' => $id,
            'likes_count' => Article::query()->whereKey($id)->pluck('likes_count')->first(),
            'status' => false,
        ];
    }
}
