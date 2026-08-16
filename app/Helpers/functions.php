<?php
function config_value(string $key, mixed $default=null): mixed { static $cfg=null; $cfg ??= require __DIR__.'/../../config/config.php'; $v=$cfg; foreach(explode('.',$key) as $p){ if(!is_array($v)||!array_key_exists($p,$v)) return $default; $v=$v[$p]; } return $v; }
function e(mixed $v): string { return htmlspecialchars((string)$v, ENT_QUOTES|ENT_SUBSTITUTE, 'UTF-8'); }
function url(string $path=''): string { return rtrim(config_value('app.url',''),'/').'/'.ltrim($path,'/'); }
function csrf_token(): string { if(empty($_SESSION['_csrf'])) $_SESSION['_csrf']=bin2hex(random_bytes(32)); return $_SESSION['_csrf']; }
function csrf_field(): string { return '<input type="hidden" name="_csrf" value="'.e(csrf_token()).'">'; }
function verify_csrf(): void { $t=$_POST['_csrf'] ?? $_SERVER['HTTP_X_CSRF_TOKEN'] ?? ''; if(!hash_equals($_SESSION['_csrf'] ?? '', $t)){ http_response_code(419); exit('Invalid security token.'); } }
function redirect(string $to): never { header('Location: '.$to); exit; }
function json_response(array $payload,int $status=200): never { http_response_code($status); header('Content-Type: application/json'); echo json_encode($payload, JSON_UNESCAPED_SLASHES); exit; }
function app_log(string $message,array $ctx=[]): void { file_put_contents(__DIR__.'/../../storage/logs/app.log',date('c').' '.$message.' '.json_encode($ctx).PHP_EOL,FILE_APPEND); }
