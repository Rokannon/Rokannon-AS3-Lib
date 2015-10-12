package com.rokannon.core.command
{
    import com.rokannon.core.Broadcaster;
    import com.rokannon.core.command.enum.CommandState;
    import com.rokannon.core.command.enum.ExecutorState;
    import com.rokannon.core.pool.ObjectPool;
    import com.rokannon.core.utils.callOutStack;

    import flash.utils.clearInterval;

    public class CommandExecutor
    {
        private static const objectPool:ObjectPool = ObjectPool.instance;

        public const eventExecuteStart:Broadcaster = new Broadcaster(this);
        public const eventExecuteEnd:Broadcaster = new Broadcaster(this);

        private const _commandsQueue:Vector.<QueueItem> = new <QueueItem>[];
        private var _insertPointer:int = 0;
        private var _lastCommandResult:Boolean = true;
        private var _executorState:String = ExecutorState.IDLE;
        private var _waitingInterval:uint = 0;

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
            if (_executorState == ExecutorState.IDLE)
            {
                executeNext();
                eventExecuteStart.broadcast();
            }
        }

        public function pushMethod(method:Function, prevCommandResult:Boolean = true, params:Object = null):void
        {
            pushCommand(new MethodCommand(method, params), prevCommandResult);
        }

        public function get isExecuting():Boolean
        {
            return _executorState != ExecutorState.IDLE;
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
            if (_executorState == ExecutorState.WAITING)
            {
                _executorState = ExecutorState.IDLE;
                clearInterval(_waitingInterval);
                eventExecuteEnd.broadcast();
            }
        }

        private function executeNext():void
        {
            _executorState = ExecutorState.WAITING;
            _waitingInterval = callOutStack(doExecuteNext, 0);
        }

        private function onCommandFinished(command:CommandBase):void
        {
            command.eventComplete.remove(onCommandFinished);
            command.eventFailed.remove(onCommandFinished);
            if (_commandsQueue.length > 0)
            {
                _lastCommandResult = command.state == CommandState.COMPLETE;
                executeNext();
            }
            else
            {
                _lastCommandResult = true;
                _executorState = ExecutorState.IDLE;
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
            _insertPointer = 0;
            var queueItem:QueueItem = _commandsQueue.shift();
            if (queueItem.prevCommandResult == _lastCommandResult)
            {
                _executorState = ExecutorState.EXECUTING;
                var command:CommandBase = queueItem.command;
                command.eventComplete.add(onCommandFinished);
                command.eventFailed.add(onCommandFinished);
                command.execute();
            }
            else if (_commandsQueue.length > 0)
                executeNext();
            else
            {
                _executorState = ExecutorState.IDLE;
                eventExecuteEnd.broadcast();
            }
            objectPool.releaseObject(queueItem);
        }
    }
}