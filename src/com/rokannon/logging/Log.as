package com.rokannon.logging
{
    import com.rokannon.core.ClassUtilsCache;
    import com.rokannon.core.errors.SingletonClassError;

    import flash.utils.Dictionary;

    public class Log
    {
        public static const instance:Log = new Log();

        private static const classUtilsCache:ClassUtilsCache = ClassUtilsCache.instance;

        private const _loggerByName:Dictionary = new Dictionary();
        private const _logTargets:Vector.<LogTarget> = new Vector.<LogTarget>();

        public function Log()
        {
            if (instance != null)
                throw new SingletonClassError();
        }

        public function getLogger(source:*):Logger
        {
            var name:String = createNameBySource(source);
            var logger:Logger;
            if (name in _loggerByName)
                logger = _loggerByName[name];
            else
            {
                logger = new Logger(name);
                _loggerByName[name] = logger;
                for each (var logTarget:LogTarget in _logTargets)
                {
                    if (logTarget.filter.checkName(logger.name))
                        logTarget.addLogger(logger);
                }
            }
            return logger
        }

        internal function updateLogTarget(logTarget:LogTarget):void
        {
            var index:int = _logTargets.indexOf(logTarget);
            if (index == -1)
            {
                _logTargets.push(logTarget);
                logTarget.eventFilterChanged.add(updateLogTarget);
            }
            logTarget.removeAllLoggers();
            for each (var logger:Logger in _loggerByName)
            {
                if (logTarget.filter.checkName(logger.name))
                    logTarget.addLogger(logger);
            }
        }

        private static function createNameBySource(source:*):String
        {
            if (source is String)
                return source;
            return classUtilsCache.getQualifiedClassName(source);
        }
    }
}