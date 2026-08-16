<?php
namespace App\Middleware; final class Auth { public static function user(): ?array { return $_SESSION['user'] ?? null; } public static function requireUser(): void { if(!self::user()) \redirect('/login'); } public static function requireAdmin(): void { if(empty($_SESSION['admin'])) \redirect('/admin/login'); }}
