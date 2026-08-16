<?php
namespace App\AI; interface AIProviderInterface { public function name(): string; public function generate(array $messages,array $options=[]): array; }
