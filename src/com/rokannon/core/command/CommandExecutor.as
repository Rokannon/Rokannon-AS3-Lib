package com.rokannon.core.command
{
    import com.rokannon.core.Broadcaster;

    public class CommandExecutor
    {
        public const eventExecuteStart:Broadcaster = new Broadcaster(this);
        public const eventExecuteEnd:Broadcaster = new Broadcaster(this);

        private const _commands:Vector.<CommandBase> = new <CommandBase>[];
        private var _isExecuting:Boolean = false;

        public function CommandExecutor()
        {
        }

        public function pushCommand(command:CommandBase):void
        {
            _commands.push(command);
            if (!_isExecuting)
                executeNext();
        }

        public function get isExecuting():Boolean
        {
            return _isExecuting;
        }

        private function executeNext():void
        {
            var command:CommandBase = _commands.shift();
            command.eventComplete.add(onCommandFinished);
            command.eventFailed.add(onCommandFinished);
            if (!_isExecuting)
            {
                _isExecuting = true;
                eventExecuteStart.broadcast();
            }
            command.execute();
        }

        private function onCommandFinished(command:CommandBase):void
        {
            command.eventComplete.remove(onCommandFinished);
            command.eventFailed.remove(onCommandFinished);
            if (_commands.length > 0)
                executeNext();
            else
            {
                _isExecuting = false;
                eventExecuteEnd.broadcast();
            }
        }
    }
}