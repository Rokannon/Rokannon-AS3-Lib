package com.rokannon.core.command
{
    public class SequenceCommand extends CompositeCommand
    {
        private var _currentCommandIndex:uint = 0;

        public function SequenceCommand()
        {
            super();
        }

        override protected function onStart():void
        {
            startNext();
        }

        private function onCommandComplete(command:CommandBase):void
        {
            command.eventComplete.remove(onCommandComplete);
            command.eventFailed.remove(onCommandFailed);
            startNext();
        }

        private function onCommandFailed(command:CommandBase):void
        {
            command.eventComplete.remove(onCommandComplete);
            command.eventFailed.remove(onCommandFailed);
            onFailed();
        }

        [Inline]
        private final function startNext():void
        {
            if (_currentCommandIndex == _commands.length)
                onComplete();
            else
            {
                var currentCommand:CommandBase;
                currentCommand = _commands[_currentCommandIndex++];
                currentCommand.eventComplete.add(onCommandComplete);
                currentCommand.eventFailed.add(onCommandFailed);
                currentCommand.execute();
            }
        }
    }
}