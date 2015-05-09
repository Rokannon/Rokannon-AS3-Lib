package com.rokannon.logging
{
    import com.rokannon.logging.enum.LogLevel;

    public class ThrowLogTarget extends LogTarget
    {
        public function ThrowLogTarget()
        {
            super();
        }

        override protected function log(loggerName:String, logLevel:uint, message:String):void
        {
            throw new Error("[" + LogLevel.toString(logLevel) + "] [" + loggerName + "] " + message);
        }
    }
}