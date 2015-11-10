package com.rokannon.logging
{
    import com.rokannon.core.utils.string.stringFormat;
    import com.rokannon.logging.enum.LogLevel;

    public class Logger
    {
        private const _callbacks:Vector.<Function> = new <Function>[];

        private var _name:String;

        public function Logger(name:String)
        {
            _name = name;
        }

        public function get name():String
        {
            return _name;
        }

        public function debug(message:String, ...rest):void
        {
            log(LogLevel.DEBUG, message, rest);
        }

        public function info(message:String, ...rest):void
        {
            log(LogLevel.INFO, message, rest);
        }

        public function warn(message:String, ...rest):void
        {
            log(LogLevel.WARN, message, rest);
        }

        public function error(message:String, ...rest):void
        {
            log(LogLevel.ERROR, message, rest);
        }

        public function fatal(message:String, ...rest):void
        {
            log(LogLevel.FATAL, message, rest);
        }

        internal function addCallback(callback:Function):void
        {
            var index:int = _callbacks.indexOf(callback);
            if (index == -1)
                _callbacks.push(callback);
        }

        internal function removeCallback(callback:Function):void
        {
            var index:int = _callbacks.indexOf(callback);
            if (index != -1)
                _callbacks.splice(index, 1);
        }

        private function log(logLevel:uint, message:String, rest:Array):void
        {
            if (rest.length != 0)
            {
                rest.unshift(message);
                message = stringFormat.apply(null, rest);
            }
            var length:int = _callbacks.length;
            for (var i:int = 0; i < length; ++i)
                _callbacks[i](this, logLevel, message);
        }
    }
}