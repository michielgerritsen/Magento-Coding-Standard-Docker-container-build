<?php
// phpcs:ignoreFile
namespace Example;

class Annotated
{
    public function getData()
    {
        $values = array();
        $values[] = $_GET['id'];

        return $values;
    }
}
