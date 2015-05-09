package com.rokannon.logging.enum
{
    import com.rokannon.core.StaticClassBase;

    public class LogLevel extends StaticClassBase
    {
        public static const NONE:uint = 0;
        public static const DEBUG:uint = 1;
        public static const INFO:uint = 2;
        public static const WARN:uint = 4;
        public static const ERROR:uint = 8;
        public static const FATAL:uint = 16;
        public static const ALL:uint = uint.MAX_VALUE;

        private static const names:Vector.<String> = new <String>["DEBUG", "INFO", "WARN", "ERROR", "FATAL"];

        public static function toString(logLevel:uint):String
        {
            if (logLevel == 0)
                return "NONE";
            var string:String;
            var counter:int = 0;
            var length:int = names.length;
            for (var i:int = 0; i < length; ++i)
            {
                if ((LogLevel[names[i]] & logLevel) == 0)
                    continue;
                ++counter;
                if (string == null)
                    string = names[i];
                else
                    string += "|" + names[i];
            }
            if (counter == length)
                string = "ALL";
            return string;
        }

        public static function fromString(string:String):uint
        {
            var logLevel:uint = 0;
            for each (var name:String in string.toUpperCase().split("|"))
            {
                var index:int = names.indexOf(name);
                if (index != -1)
                    logLevel |= LogLevel[names[index]];
            }
            return logLevel;
        }
    }
}