package com.rokannon.command.directoryDelete
{
    import com.rokannon.core.command.CommandBase;
    import com.rokannon.logging.Log;
    import com.rokannon.logging.Logger;

    import flash.events.Event;
    import flash.events.IOErrorEvent;

    public class DirectoryDeleteCommand extends CommandBase
    {
        private static const logger:Logger = Log.instance.getLogger(DirectoryDeleteCommand);

        private var _context:DirectoryDeleteContext;

        public function DirectoryDeleteCommand(context:DirectoryDeleteContext)
        {
            super();
            _context = context;
        }

        override protected function onStart():void
        {
            _context.directoryToDelete.addEventListener(Event.COMPLETE, onDeleteComplete);
            _context.directoryToDelete.addEventListener(IOErrorEvent.IO_ERROR, onDeleteError);
            _context.directoryToDelete.deleteDirectoryAsync(true);
        }

        private function onDeleteError(event:IOErrorEvent):void
        {
            _context.directoryToDelete.removeEventListener(Event.COMPLETE, onDeleteComplete);
            _context.directoryToDelete.removeEventListener(IOErrorEvent.IO_ERROR, onDeleteError);
            CONFIG::log_error
            {
                logger.error("Failed to delete directory: {0}", _context.directoryToDelete);
            }
            if (_context.failOnError)
                onFailed();
            else
                onComplete();
        }

        private function onDeleteComplete(event:Event):void
        {
            _context.directoryToDelete.removeEventListener(Event.COMPLETE, onDeleteComplete);
            _context.directoryToDelete.removeEventListener(IOErrorEvent.IO_ERROR, onDeleteError);
            onComplete();
        }
    }
}