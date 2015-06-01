package com.rokannon.core.command
{
    import com.rokannon.core.pool.IPoolObject;

    internal class QueueItem implements IPoolObject
    {
        public var command:CommandBase;
        public var prevCommandResult:Boolean;

        public function resetPoolObject():void
        {
            command = null;
            prevCommandResult = false;
        }
    }
}