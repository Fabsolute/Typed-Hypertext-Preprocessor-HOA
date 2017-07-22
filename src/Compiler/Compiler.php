<?php

namespace THP\Compiler;


use Hoa\Compiler\Llk\Llk;
use Hoa\Compiler\Visitor\Dump;
use Hoa\File\Read;

class Compiler
{
    public static function compile($file_name)
    {
        $ast = self::getCompiler()->parse((new Read($file_name))->readAll(), 'thp');
        $dump = new Dump();
        echo '<pre>' . htmlspecialchars($dump->visit($ast));
    }

    public static function check($file_name)
    {
        $ast = self::getCompiler()->parse((new Read($file_name))->readAll(), 'thp', false);
        return $ast;
    }

    private static function getCompiler()
    {
        return Llk::load(new Read(BASE_PATH . '/src/Compiler/Grammar.pp'));
    }
}