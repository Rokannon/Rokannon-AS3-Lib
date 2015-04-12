package com.rokannon.core.utils.string
{
    public function stringFormat(string:String, ...args):String
    {
        return string.replace(/\{([0-9]+)\}/g, function ():String
        {
            var token:String = arguments[0];
            var index:int = parseInt(token.substr(1, token.length - 2));
            return index < args.length ? args[index] : arguments[0];
        });
    }
}