package com.rokannon.logging
{
    import com.rokannon.logging.enum.LogLevel;

    public class TraceLogTarget extends LogTarget
    {
        public function TraceLogTarget()
        {
            super();
        }

        override protected function log(loggerName:String, logLevel:uint, message:String):void
        {
            trace("[" + LogLevel.toString(logLevel) + "] [" + loggerName + "] " + message);
        }
    }
}