package com.rokannon.core.utils
{
    import flash.utils.clearInterval;
    import flash.utils.setInterval;

    public function callOutStack(method:Function, delayMs:Number = 0, ...args):uint
    {
        var interval:uint = setInterval(function ():void
        {
            clearInterval(interval);
            method.apply(null, args);
        }, delayMs);
        return interval;
    }
}