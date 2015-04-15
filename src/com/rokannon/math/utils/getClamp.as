package com.rokannon.math.utils
{
    public function getClamp(x:Number, min:Number, max:Number):Number
    {
        return x < min ? min : (x > max ? max : x);
    }
}