<?php
return file_exists(__DIR__.'/config.local.php') ? require __DIR__.'/config.local.php' : require __DIR__.'/config.example.php';
