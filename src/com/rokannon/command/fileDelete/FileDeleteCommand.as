package com.rokannon.command.fileDelete
{
    import com.rokannon.core.command.CommandBase;
    import com.rokannon.logging.Log;
    import com.rokannon.logging.Logger;

    import flash.events.Event;
    import flash.events.IOErrorEvent;

    public class FileDeleteCommand extends CommandBase
    {
        private static const logger:Logger = Log.instance.getLogger(FileDeleteCommand);

        private var _context:FileDeleteContext;

        public function FileDeleteCommand(context:FileDeleteContext)
        {
            super();
            _context = context;
        }

        override protected function onStart():void
        {
            _context.fileToDelete.addEventListener(Event.COMPLETE, onDeleteComplete);
            _context.fileToDelete.addEventListener(IOErrorEvent.IO_ERROR, onDeleteError);
            _context.fileToDelete.deleteFileAsync();
        }

        private function onDeleteError(event:IOErrorEvent):void
        {
            _context.fileToDelete.removeEventListener(Event.COMPLETE, onDeleteComplete);
            _context.fileToDelete.removeEventListener(IOErrorEvent.IO_ERROR, onDeleteError);
            CONFIG::log_error
            {
                logger.error("Failed to delete file: {0}", _context.fileToDelete.nativePath);
            }
            if (_context.failOnError)
                onFailed();
            else
                onComplete();
        }

        private function onDeleteComplete(event:Event):void
        {
            _context.fileToDelete.removeEventListener(Event.COMPLETE, onDeleteComplete);
            _context.fileToDelete.removeEventListener(IOErrorEvent.IO_ERROR, onDeleteError);
            onComplete();
        }
    }
}