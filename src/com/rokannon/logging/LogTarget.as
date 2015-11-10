package com.rokannon.logging
{
    import com.rokannon.core.Broadcaster;
    import com.rokannon.core.errors.AbstractMethodError;

    public class LogTarget
    {
        public const filter:LogFilter = new LogFilter(this);

        internal const eventFilterChanged:Broadcaster = new Broadcaster(this);

        private const _loggers:Vector.<Logger> = new <Logger>[];

        public function LogTarget()
        {
            Log.instance.updateLogTarget(this);
        }

        protected function log(loggerName:String, logLevel:uint, message:String):void
        {
            throw new AbstractMethodError();
        }

        internal function addLogger(logger:Logger):void
        {
            logger.addCallback(onLoggerMessage);
            _loggers.push(logger);
        }

        internal function removeAllLoggers():void
        {
            for each (var logger:Logger in _loggers)
                logger.removeCallback(onLoggerMessage);
            _loggers.length = 0;
        }

        private function onLoggerMessage(logger:Logger, logLevel:uint, message:String):void
        {
            if (filter.checkLevel(logLevel) && filter.checkName(logger.name))
                log(logger.name, logLevel, message);
        }
    }
}