<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Database\Eloquent\Builder;
use App\Comment;
use App\Article;
use App\ArticleLike;

class BlogController extends Controller
{
    protected function articleWithLike($ipAddress)
    {
        return [
            'like as like' => function (Builder $query) use ($ipAddress) {
                $query->where('ip_address', $ipAddress);
            }
        ];
    }

    public function commentCreate(Request $request)
    {
        $data = $request->validate([
            'article_id' => 'required|exists:articles,id',
            'subject' => 'required|string|min:1',
            'body' => 'required|string|min:1',
        ]);

        $comment = new Comment();
        $comment->article_id = $data['article_id'];
        $comment->subject = $data['subject'];
        $comment->body = $data['body'];
        $comment->saveOrFail();

        return $comment;
    }

    public function commentList($id)
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
            ->orderByDesc('created_at')
            ->limit(6)
            ->get();
    }

    public function articles(Request $request)
    {
        return Article::query()
            ->withCount($this->articleWithLike($request->ip()))
            ->orderByDesc('created_at')
            ->paginate(10);
    }

    public function getArticle($id, Request $request)
    {
        return Article::query()
            ->with('articleTags')
            ->withCount($this->articleWithLike($request->ip()))
            ->findOrFail($id);
    }

    public function articleView(Request $request)
    {
        $data = $request->validate([
            'article_id' => 'required|exists:articles,id',
        ]);

        Article::query()->where('id', $data['article_id'])->increment('views_count');
        /** @var Article $article */
        $article = Article::query()->find($data['article_id']);

        return [
            'views_count' => $article->views_count,
        ];
    }

    public function articleLike(Request $request)
    {
        $id = $request->input('article_id');
        /** @var Article $article */
        $article = Article::query()->findOrFail($id);

        ArticleLike::unguard();
        $attributes = [
            'article_id' => $id,
            'ip_address' => $request->ip(),
        ];
        $like = ArticleLike::query()
            ->where($attributes)
            ->firstOrNew($attributes);
        ArticleLike::reguard();

        if (!$like->exists) {
            $like->saveOrFail();
            $article->newQuery()->whereKey($article->id)->increment('likes_count');
            $article->refresh();
        }

        return [
            'id' => $article->id,
            'likes_count' => $article->likes_count,
            'status' => true,
        ];
    }

    public function articleUnlike(Request $request)
    {
        $id = $request->input('article_id');
        /** @var Article $article */
        $article = Article::query()->findOrFail($id);
        $deleted = ArticleLike::query()
            ->where([
                'article_id' => $id,
                'ip_address' => $request->ip(),
            ])->delete();

        if ($deleted) {
            $article->newQuery()->whereKey($article->id)->decrement('likes_count');
            $article->refresh();
        }

        return [
            'id' => $article->id,
            'likes_count' => $article->likes_count,
            'status' => false,
        ];
    }
}
