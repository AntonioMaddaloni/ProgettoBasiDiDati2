<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Log;
use MongoDB\Client;

class MongoDBServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     */
    public function register(): void
    {
        $this->app->bind('mongodb', function ($app) {
            $config = config('database.connections.mongodb');
            try{
                $connection = new Client("mongodb://{$config['host']}:{$config['port']}");
                $database = $connection->selectDatabase($config['database']);
                Log::info('Ho ottenuto la connessione');
                return $database;
            }catch(\Error $e)
            {
                Log::info('Connessione al database fallita');
            }
        });
    }

    /**
     * Bootstrap services.
     */
    public function boot(): void
    {
        //
    }
}
