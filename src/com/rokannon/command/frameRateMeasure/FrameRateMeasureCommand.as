package com.rokannon.command.frameRateMeasure
{
    import com.rokannon.core.command.CommandBase;

    import flash.events.Event;
    import flash.utils.getTimer;

    public class FrameRateMeasureCommand extends CommandBase
    {
        private var _context:FrameRateMeasureContext;
        private var _numFrames:int;
        private var _startTime:uint;

        public function FrameRateMeasureCommand(context:FrameRateMeasureContext)
        {
            super();
            _context = context;
        }

        override protected function onStart():void
        {
            _numFrames = 0;
            _startTime = getTimer();
            _context.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private function onEnterFrame(event:Event):void
        {
            ++_numFrames;
            var timePassed:uint = getTimer() - _startTime;
            if (timePassed > _context.timeToMeasure)
            {
                _context.measuredFrameRate = 1000 / (timePassed / _numFrames);
                _context.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
                onComplete();
            }
        }
    }
}