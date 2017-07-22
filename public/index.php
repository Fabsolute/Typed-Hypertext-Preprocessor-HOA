<?php

define('BASE_PATH', dirname(__DIR__));

use THP\Compiler\Compiler;

require_once('../vendor/autoload.php');

Compiler::compile(BASE_PATH . '/public/test.thp');
