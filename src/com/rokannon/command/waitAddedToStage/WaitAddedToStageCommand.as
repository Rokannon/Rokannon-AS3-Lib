package com.rokannon.command.waitAddedToStage
{
    import com.rokannon.core.command.CommandBase;

    import flash.events.Event;

    public class WaitAddedToStageCommand extends CommandBase
    {
        private var _context:WaitAddedToStageContext;

        public function WaitAddedToStageCommand(context:WaitAddedToStageContext)
        {
            super();
            _context = context;
        }

        override protected function onStart():void
        {
            if (_context.displayObjecToWait.stage != null)
                onComplete();
            else
                _context.displayObjecToWait.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

        private function onAddedToStage(event:Event):void
        {
            _context.displayObjecToWait.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            onComplete();
        }
    }
}