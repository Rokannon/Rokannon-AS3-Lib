package com.rokannon.core.command.enum
{
    import com.rokannon.core.StaticClassBase;

    public class ExecutorState extends StaticClassBase
    {
        public static const IDLE:String = "idle";
        public static const WAITING:String = "waiting";
        public static const EXECUTING:String = "executing";
    }
}