package com.rokannon.logging
{
    import com.rokannon.logging.enum.LogLevel;

    public class LogFilter
    {
        public const nameFilter:Vector.<String> = new <String>[];

        public var levelFilter:uint;

        private const _nameFilter:Vector.<String> = new <String>[];

        private var _levelFilter:uint;
        private var _logTarget:LogTarget;

        public function LogFilter(logTarget:LogTarget)
        {
            _logTarget = logTarget;
            levelFilter = LogLevel.ALL;
        }

        public function checkLevel(logLevel:uint):Boolean
        {
            checkFilterChange();
            return (logLevel & _levelFilter) != 0;
        }

        public function checkName(name:String):Boolean
        {
            checkFilterChange();
            if (_nameFilter.length == 0)
                return true;
            for each (var filter:String in _nameFilter)
            {
                if (name.indexOf(filter) == 0)
                    return true;
            }
            return false;
        }

        public function toString():String
        {
            checkFilterChange();
            var object:Object = {
                levelFilter: LogLevel.toString(_levelFilter), nameFilter: (_nameFilter.length == 0 ? "*" : _nameFilter)
            };
            return JSON.stringify(object);
        }

        private function checkFilterChange():void
        {
            var i:int;
            var filterChanged:Boolean = false;
            if (_levelFilter != levelFilter || !compareNameFilters(nameFilter))
                filterChanged = true;
            if (filterChanged)
            {
                _levelFilter = levelFilter;
                _nameFilter.length = 0;
                var length:int = nameFilter.length;
                for (i = 0; i < length; ++i)
                    _nameFilter[i] = nameFilter[i];
                _logTarget.eventFilterChanged.broadcast();
            }
        }

        private function compareNameFilters(nameFilter:Vector.<String>):Boolean
        {
            if (_nameFilter.length != nameFilter.length)
                return false;
            for (var i:int = _nameFilter.length - 1; i >= 0; --i)
            {
                if (_nameFilter[i] != nameFilter[i])
                    return false;
            }
            return true;
        }
    }
}