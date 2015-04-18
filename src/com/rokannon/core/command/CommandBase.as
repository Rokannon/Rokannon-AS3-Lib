package com.rokannon.core.command
{
    import com.rokannon.core.Broadcaster;
    import com.rokannon.core.command.enum.CommandState;
    import com.rokannon.core.errors.AbstractMethodError;

    public class CommandBase
    {
        public const eventComplete:Broadcaster = new Broadcaster(this);
        public const eventFailed:Broadcaster = new Broadcaster(this);

        private var _state:String = CommandState.INITIAL;

        public function CommandBase()
        {
        }

        public final function get state():String
        {
            return _state;
        }

        public final function execute():void
        {
            if (_state == CommandState.INITIAL)
            {
                _state = CommandState.IN_PROGRESS;
                onStart();
            }
        }

        protected function onStart():void
        {
            throw new AbstractMethodError();
        }

        protected final function onComplete():void
        {
            _state = CommandState.COMPLETE;
            eventComplete.broadcast();
        }

        protected final function onFailed():void
        {
            _state = CommandState.FAILED;
            eventFailed.broadcast();
        }
    }
}