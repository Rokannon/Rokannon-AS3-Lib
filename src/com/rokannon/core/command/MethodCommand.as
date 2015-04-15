package com.rokannon.core.command
{
    public class MethodCommand extends CommandBase
    {
        private var _method:Function;

        public function MethodCommand(method:Function)
        {
            super();
            _method = method;
        }

        override protected function onStart():void
        {
            if (_method())
                onComplete();
            else
                onFailed();
        }
    }
}