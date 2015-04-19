package com.rokannon.core.command
{
    public class MethodCommand extends CommandBase
    {
        private var _method:Function;
        private var _params:Object;

        public function MethodCommand(method:Function, params:Object)
        {
            super();
            _method = method;
            _params = params;
        }

        override protected function onStart():void
        {
            var result:Boolean;
            if (_method.length == 0)
                result = _method();
            else
                result = _method(_params);
            if (result)
                onComplete();
            else
                onFailed();
        }
    }
}