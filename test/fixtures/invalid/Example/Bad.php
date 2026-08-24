<?php
namespace Example;

class Bad
{
    public function getData()
    {
        $values = array();
        $values[] = $_GET['id'];

        return $values;
    }
}
