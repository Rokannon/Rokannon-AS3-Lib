package com.rokannon.math.utils
{
    public function getFloor(x:Number):Number
    {
        if (x < 0)
        {
            var value:Number = x << 0;
            return x == value ? value : value - 1;
        }
        return x << 0;
    }
}