package com.rokannon.core.utils
{
    public function getRandomColor(minChannel:int = 0, maxChannel:int = 0xFF):uint
    {
        var r:uint = minChannel + (maxChannel - minChannel) * Math.random();
        var g:uint = minChannel + (maxChannel - minChannel) * Math.random();
        var b:uint = minChannel + (maxChannel - minChannel) * Math.random();
        return (r << 16) | (g << 8) | b;
    }
}