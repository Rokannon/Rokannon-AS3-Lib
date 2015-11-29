package com.rokannon.command.timeDelay
{
    import com.rokannon.core.command.CommandBase;
    import com.rokannon.core.utils.callOutStack;

    public class TimeDelayCommand extends CommandBase
    {
        private var _context:TimeDelayContext;

        public function TimeDelayCommand(context:TimeDelayContext)
        {
            super();
            _context = context;
        }

        override protected function onStart():void
        {
            callOutStack(onComplete, _context.timeSeconds * 1000);
        }
    }
}