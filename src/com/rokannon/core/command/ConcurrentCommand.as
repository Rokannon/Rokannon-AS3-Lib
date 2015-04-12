package com.rokannon.core.command
{
    public class ConcurrentCommand extends CompositeCommand
    {
        private var _numCompleteCommands:uint = 0;
        private var _numFailedCommands:uint = 0;

        public function ConcurrentCommand()
        {
            super();
        }

        override protected function onStart():void
        {
            if (_commands.length == 0)
                onComplete();
            else
            {
                for each (var command:CommandBase in _commands)
                {
                    command.eventComplete.add(onCommandComplete);
                    command.eventFailed.add(onCommandFailed);
                    command.execute();
                }
            }
        }

        private function onCommandComplete(command:CommandBase):void
        {
            command.eventComplete.remove(onCommandComplete);
            command.eventFailed.remove(onCommandFailed);
            ++_numCompleteCommands;
            tryFinishCommand();
        }

        private function onCommandFailed(command:CommandBase):void
        {
            command.eventComplete.remove(onCommandComplete);
            command.eventFailed.remove(onCommandFailed);
            ++_numFailedCommands;
            tryFinishCommand();
        }

        [Inline]
        private final function tryFinishCommand():void
        {
            if (_numCompleteCommands + _numFailedCommands < _commands.length)
                return;
            if (_numFailedCommands > 0)
                onFailed();
            else
                onComplete();
        }
    }
}