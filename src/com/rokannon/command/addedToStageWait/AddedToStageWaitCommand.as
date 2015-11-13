package com.rokannon.command.addedToStageWait
{
    import com.rokannon.core.command.CommandBase;

    import flash.events.Event;

    public class AddedToStageWaitCommand extends CommandBase
    {
        private var _context:AddedToStageWaitContext;

        public function AddedToStageWaitCommand(context:AddedToStageWaitContext)
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