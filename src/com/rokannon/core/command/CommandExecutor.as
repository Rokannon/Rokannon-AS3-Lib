package com.rokannon.core.command
{
    import com.rokannon.core.Broadcaster;
    import com.rokannon.core.command.enum.CommandState;
    import com.rokannon.core.utils.callOutStack;

    public class CommandExecutor
    {
        public const eventExecuteStart:Broadcaster = new Broadcaster(this);
        public const eventExecuteEnd:Broadcaster = new Broadcaster(this);

        private const _commandsQueue:Vector.<CommandBase> = new <CommandBase>[];
        private var _isExecuting:Boolean = false;
        private var _executeNextPending:Boolean = false;
        private var _insertPointer:int = 0;
        private var _lastCommandResult:String = CommandState.INITIAL;

        public function CommandExecutor()
        {
        }

        public function pushCommand(command:CommandBase):void
        {
            insertCommandAt(command, _insertPointer);
            ++_insertPointer;
            if (!_isExecuting)
                executeNext();
        }

        public function pushMethod(method:Function):void
        {
            pushCommand(new MethodCommand(method));
        }

        public function get isExecuting():Boolean
        {
            return _isExecuting;
        }

        public function get lastCommandResult():String
        {
            return _lastCommandResult;
        }

        public function removeAllCommands():void
        {
            _commandsQueue.length = 0;
            _insertPointer = 0;
        }

        private function executeNext():void
        {
            if (!_executeNextPending)
            {
                _executeNextPending = true;
                callOutStack(doExecuteNext);
            }
        }

        private function onCommandFinished(command:CommandBase):void
        {
            command.eventComplete.remove(onCommandFinished);
            command.eventFailed.remove(onCommandFinished);
            _lastCommandResult = command.state;
            if (_commandsQueue.length > 0)
                executeNext();
            else
            {
                _isExecuting = false;
                eventExecuteEnd.broadcast();
            }
        }

        private function insertCommandAt(command:CommandBase, index:int):void
        {
            _commandsQueue.push(null);
            for (var i:int = _commandsQueue.length - 1; i > index; --i)
                _commandsQueue[i] = _commandsQueue[i - 1];
            _commandsQueue[index] = command;
        }

        private function doExecuteNext():void
        {
            _executeNextPending = false;
            var command:CommandBase = _commandsQueue.shift();
            command.eventComplete.add(onCommandFinished);
            command.eventFailed.add(onCommandFinished);
            if (!_isExecuting)
            {
                _isExecuting = true;
                eventExecuteStart.broadcast();
            }
            _insertPointer = 0;
            command.execute();
        }
    }
}