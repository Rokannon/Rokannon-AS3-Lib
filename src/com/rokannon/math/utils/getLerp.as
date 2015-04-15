package com.rokannon.math.utils
{
    public function getLerp(value1:Number, value2:Number, t:Number):Number
    {
        return value1 + t * (value2 - value1);
    }
}