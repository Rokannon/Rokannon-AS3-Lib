package com.rokannon.command.frameRateMeasure
{
    import flash.display.Stage;

    public class FrameRateMeasureContext
    {
        public var measuredFrameRate:Number;
        public var stage:Stage;
        public var timeToMeasure:int = 1000;

        public function FrameRateMeasureContext()
        {
        }
    }
}