package com.rokannon.core.command
{
    public class ConcurrentCommand extends CompositeCommand
    {
        private var _currentCommandIndex:uint = 0;
        private var _numFailedCommands:uint = 0;
        private var _numRunningCommands:uint = 0;
        private var _maxRunningCommands:uint;

        public function ConcurrentCommand(maxRunningCommands:uint = 0)
        {
            super();
            _maxRunningCommands = maxRunningCommands;
        }

        override protected function onStart():void
        {
            if (_commands.length == 0)
                onComplete();
            else
            {
                while ((_maxRunningCommands == 0 || _numRunningCommands < _maxRunningCommands) && _currentCommandIndex < _commands.length)
                    startNext();
            }
        }

        private function onCommandComplete(command:CommandBase):void
        {
            command.eventComplete.remove(onCommandComplete);
            command.eventFailed.remove(onCommandFailed);
            --_numRunningCommands;
            tryFinishCommand();
        }

        private function onCommandFailed(command:CommandBase):void
        {
            command.eventComplete.remove(onCommandComplete);
            command.eventFailed.remove(onCommandFailed);
            --_numRunningCommands;
            ++_numFailedCommands;
            tryFinishCommand();
        }

        private function startNext():void
        {
            var command:CommandBase = _commands[_currentCommandIndex];
            ++_currentCommandIndex;
            ++_numRunningCommands;
            command.eventComplete.add(onCommandComplete);
            command.eventFailed.add(onCommandFailed);
            command.execute();
        }

        [Inline]
        private final function tryFinishCommand():void
        {
            if (_currentCommandIndex < _commands.length)
                startNext();
            else if (_numRunningCommands == 0)
            {
                if (_numFailedCommands > 0)
                    onFailed();
                else
                    onComplete();
            }
        }
    }
}