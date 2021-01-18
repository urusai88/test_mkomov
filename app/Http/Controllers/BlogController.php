<?php

namespace App\Http\Controllers;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Relations\HasOne;
use \Throwable;
use App\ArticlesLike;
use App\Article;
use App\Comment;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator;

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

    /**
     * @param Request $request
     * @return Comment
     * @throws Throwable
     */
    public function createComment(Request $request)
    {
        $data = $request->validate([
            'article_id' => 'required|exists:articles,id',
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

    public function articlesLast(Request $request)
    {
        return Article::query()
            ->withCount($this->articleWithLike($request->ip()))
            ->orderByDesc('created_at')
            ->limit(6)
            ->get();

    }

    public function articles()
    {
        /** @var LengthAwarePaginator $paginator */
        $paginator = Article::query()
            ->orderByDesc('created_at')
            ->paginate(10);
        $paginator->getCollection()->transform(function (Article $item) {
            $array = $item->toArray();
            $array['slug'] = "{$item->slug}.{$item->id}";

            return $array;
        });

        return $paginator;
    }

    public function getArticle($id)
    {
        return Article::query()->with('articleTags')->findOrFail($id);
    }

    public function articleView(Request $request)
    {
        $data = $request->validate([
            'article_id' => 'required|exists:articles,id',
        ]);

        Article::query()->where('id', $data['article_id'])->increment('views_count');
    }

    public function articleLike(Request $request)
    {
        $id = $request->input('article_id');
        /** @var Article $article */
        $article = Article::query()->findOrFail($id);

        ArticlesLike::unguard();
        $attributes = [
            'article_id' => $id,
            'ip_address' => $request->ip(),
        ];
        $like = ArticlesLike::query()
            ->where($attributes)
            ->firstOrNew($attributes);
        ArticlesLike::reguard();

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

        $deleted = ArticlesLike::query()
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

    public function likeToggle(Request $request)
    {
        $data = $request->validate([
            'article_id' => 'required|exists:articles,id',
        ]);

        $articleQuery = Article::query()->whereKey($data['article_id']);
        $like = ArticlesLike::query()
            ->where('article_id', $data['article_id'])
            ->where('ip_address', $request->ip())
            ->firstOrNew();

        if ($like->exists) {
            $like->delete();
            $articleQuery->decrement('likes_count');
        } else {
            $like->saveOrFail();
            $articleQuery->increment('likes_count');
        }

        /** @var Article $article */
        $article = $articleQuery->first();

        return [
            'id' => $article->id,
            'likes_count' => $article->likes_count,
            'status' => (int)$like->exists,
        ];
    }
}
