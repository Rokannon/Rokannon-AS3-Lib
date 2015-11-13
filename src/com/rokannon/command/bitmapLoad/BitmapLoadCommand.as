package com.rokannon.command.bitmapLoad
{
    import com.rokannon.core.command.CommandBase;
    import com.rokannon.logging.Log;
    import com.rokannon.logging.Logger;

    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;

    public class BitmapLoadCommand extends CommandBase
    {
        private static const logger:Logger = Log.instance.getLogger(BitmapLoadCommand);

        private const _loader:Loader = new Loader();

        private var _context:BitmapLoadContext;

        public function BitmapLoadCommand(context:BitmapLoadContext)
        {
            super();
            _context = context;
        }

        override protected function onStart():void
        {
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
            _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
            _loader.loadBytes(_context.bytesToLoad);
        }

        private function onLoaderComplete(event:Event):void
        {
            _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete);
            _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
            _context.bitmap = event.target.content as Bitmap;
            onComplete();
        }

        private function onLoaderError(event:IOErrorEvent):void
        {
            _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaderComplete);
            _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoaderError);
            CONFIG::log_error
            {
                logger.error("Error loading bitmap from byte array.");
            }
            onFailed();
        }
    }
}