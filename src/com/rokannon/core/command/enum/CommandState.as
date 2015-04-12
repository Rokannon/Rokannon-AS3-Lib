package com.rokannon.core.command.enum
{
    import com.rokannon.core.StaticClassBase;

    public class CommandState extends StaticClassBase
    {
        public static const INITIAL:String = "initial";
        public static const IN_PROGRESS:String = "inProgress";
        public static const COMPLETE:String = "complete";
        public static const FAILED:String = "failed";
    }
}