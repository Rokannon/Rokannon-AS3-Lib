package com.rokannon.command.invokeWait
{
    import com.rokannon.core.command.CommandBase;

    import flash.desktop.NativeApplication;
    import flash.events.InvokeEvent;

    public class InvokeWaitCommand extends CommandBase
    {
        private var _context:InvokeWaitContext;

        public function InvokeWaitCommand(context:InvokeWaitContext)
        {
            super();
            _context = context;
        }

        override protected function onStart():void
        {
            NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
        }

        private function onInvoke(event:InvokeEvent):void
        {
            var length:int = event.arguments.length;
            for (var i:int = 0; i < length; i++)
                _context.arguments[i] = event.arguments[i];
            onComplete();
        }
    }
}