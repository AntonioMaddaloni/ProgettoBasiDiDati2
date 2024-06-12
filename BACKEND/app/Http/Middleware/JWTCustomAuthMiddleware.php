<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;

class JWTCustomAuthMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        try {
            // Ottieni il token dall'header Authorization
            $token = $request->bearerToken();
    
            if (!$token) {
                return response()->json(['message' => 'token_not_provided'], 400);
            }
    
            // Verifica la validità del token senza autenticare l'utente
            JWTAuth::setToken($token)->checkOrFail();

            // Effettuo il login sulla base del token
            JWTAuth::authenticate();
            
            return $next($request);

            } catch (TokenExpiredException $e) {
                return response()->json(['message' => 'token_expired'], 401);
            } catch (TokenInvalidException $e) {
                return response()->json(['message' => 'token_invalid'], 401);
            } catch (JWTException $e) {
                return response()->json(['message' => 'token_absent'], 401);
            }
    }
}
