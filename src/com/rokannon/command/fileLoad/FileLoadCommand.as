package com.rokannon.command.fileLoad
{
    import com.rokannon.core.command.CommandBase;

    import flash.events.Event;

    import flash.events.IOErrorEvent;

    public class FileLoadCommand extends CommandBase
    {
        private var _context:FileLoadContext;

        public function FileLoadCommand(context:FileLoadContext)
        {
            super();
            _context = context;
        }

        override protected function onStart():void
        {
            _context.fileToLoad.addEventListener(Event.COMPLETE, onLoadComplete);
            _context.fileToLoad.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
            _context.fileToLoad.load();
        }

        private function onLoadError(event:IOErrorEvent):void
        {
            _context.fileToLoad.removeEventListener(Event.COMPLETE, onLoadComplete);
            _context.fileToLoad.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
            onFailed();
        }

        private function onLoadComplete(event:Event):void
        {
            _context.fileToLoad.removeEventListener(Event.COMPLETE, onLoadComplete);
            _context.fileToLoad.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
            _context.fileContent = _context.fileToLoad.data;
            onComplete();
        }
    }
}