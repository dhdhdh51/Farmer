<?php
namespace App\Services; final class View { public static function render(string $view,array $data=[]): void { extract($data, EXTR_SKIP); $viewFile=__DIR__.'/../../resources/views/'.$view.'.php'; require __DIR__.'/../../resources/views/layouts/app.php'; }}
