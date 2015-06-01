package com.rokannon.core.command
{
    import com.rokannon.core.Broadcaster;
    import com.rokannon.core.command.enum.CommandState;
    import com.rokannon.core.pool.ObjectPool;
    import com.rokannon.core.utils.callOutStack;

    public class CommandExecutor
    {
        private static const objectPool:ObjectPool = ObjectPool.instance;

        public const eventExecuteStart:Broadcaster = new Broadcaster(this);
        public const eventExecuteEnd:Broadcaster = new Broadcaster(this);

        private const _commandsQueue:Vector.<QueueItem> = new <QueueItem>[];
        private var _isExecuting:Boolean = false;
        private var _executeNextPending:Boolean = false;
        private var _insertPointer:int = 0;
        private var _lastCommandResult:Boolean = true;

        public function CommandExecutor()
        {
        }

        public function pushCommand(command:CommandBase, prevCommandResult:Boolean = true):void
        {
            var queueItem:QueueItem = QueueItem(objectPool.createObject(QueueItem));
            queueItem.command = command;
            queueItem.prevCommandResult = prevCommandResult;
            insertCommandAt(queueItem, _insertPointer);
            ++_insertPointer;
            if (!_isExecuting)
                executeNext();
        }

        public function pushMethod(method:Function, prevCommandResult:Boolean = true, params:Object = null):void
        {
            pushCommand(new MethodCommand(method, params), prevCommandResult);
        }

        public function get isExecuting():Boolean
        {
            return _isExecuting;
        }

        public function get lastCommandResult():Boolean
        {
            return _lastCommandResult;
        }

        public function removeAllCommands():void
        {
            for (var i:int = _commandsQueue.length - 1; i >= 0; --i)
                objectPool.releaseObject(_commandsQueue[i]);
            _commandsQueue.length = 0;
            _insertPointer = 0;
            _executeNextPending = false;
            if (!_isExecuting)
                _lastCommandResult = true;
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
            _lastCommandResult = command.state == CommandState.COMPLETE;
            if (_commandsQueue.length > 0)
                executeNext();
            else
            {
                _isExecuting = false;
                eventExecuteEnd.broadcast();
            }
        }

        private function insertCommandAt(queueItem:QueueItem, index:int):void
        {
            _commandsQueue.push(null);
            for (var i:int = _commandsQueue.length - 1; i > index; --i)
                _commandsQueue[i] = _commandsQueue[i - 1];
            _commandsQueue[index] = queueItem;
        }

        private function doExecuteNext():void
        {
            // This guard clause means that all commands were removed.
            if (!_executeNextPending)
                return;

            _executeNextPending = false;
            _insertPointer = 0;
            var queueItem:QueueItem = _commandsQueue.shift();
            if (queueItem.prevCommandResult == _lastCommandResult)
            {
                var command:CommandBase = queueItem.command;
                command.eventComplete.add(onCommandFinished);
                command.eventFailed.add(onCommandFinished);
                if (!_isExecuting)
                {
                    _isExecuting = true;
                    eventExecuteStart.broadcast();
                }

                command.execute();
            }
            else if (_commandsQueue.length > 0)
                executeNext();
            else if (_isExecuting)
            {
                _isExecuting = false;
                eventExecuteEnd.broadcast();
            }
            objectPool.releaseObject(queueItem);
        }
    }
}