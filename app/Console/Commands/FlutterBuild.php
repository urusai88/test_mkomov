<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\File;
use Symfony\Component\Process\Process;

class FlutterBuild extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:flutter_build';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        $process = new Process(['fvm', 'flutter', 'build', 'web', '--no-sound-null-safety'], base_path('frontend'));
        $code = $process->run(function ($type, $buffer) {
            echo $buffer;
        });

        $files = File::allFiles(base_path('frontend/build/web'));

        foreach ($files as $file) {
            $dir = base_path('public' . DIRECTORY_SEPARATOR . $file->getRelativePath());

            File::ensureDirectoryExists($dir);
            File::copy($file->getPathname(), base_path('public' . DIRECTORY_SEPARATOR . $file->getRelativePathname()));
        }

        File::copyDirectory(base_path('frontend/build'), base_path('public'));
        File::move(base_path('public/index.html'), base_path('resources/views/index.html'));

        return 0;
    }
}
