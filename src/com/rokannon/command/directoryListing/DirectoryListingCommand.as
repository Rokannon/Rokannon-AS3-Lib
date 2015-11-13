package com.rokannon.command.directoryListing
{
    import com.rokannon.core.command.CommandBase;
    import com.rokannon.logging.Log;
    import com.rokannon.logging.Logger;

    import flash.events.FileListEvent;
    import flash.events.IOErrorEvent;

    public class DirectoryListingCommand extends CommandBase
    {
        private static const logger:Logger = Log.instance.getLogger(DirectoryListingCommand);

        private var _context:DirectoryListingContext;

        public function DirectoryListingCommand(context:DirectoryListingContext)
        {
            super();
            _context = context;
        }

        override protected function onStart():void
        {
            _context.directoryToLoad.addEventListener(FileListEvent.DIRECTORY_LISTING, onListingComplete);
            _context.directoryToLoad.addEventListener(IOErrorEvent.IO_ERROR, onListingError);
            _context.directoryToLoad.getDirectoryListingAsync();
        }

        private function onListingError(event:IOErrorEvent):void
        {
            _context.directoryToLoad.removeEventListener(FileListEvent.DIRECTORY_LISTING, onListingComplete);
            _context.directoryToLoad.removeEventListener(IOErrorEvent.IO_ERROR, onListingError);
            CONFIG::log_error
            {
                logger.error("Error listing directory: {0}", _context.directoryToLoad.nativePath);
            }
            onFailed();
        }

        private function onListingComplete(event:FileListEvent):void
        {
            _context.directoryToLoad.removeEventListener(FileListEvent.DIRECTORY_LISTING, onListingComplete);
            _context.directoryToLoad.removeEventListener(IOErrorEvent.IO_ERROR, onListingError);
            var length:int = event.files.length;
            for (var i:int = 0; i < length; ++i)
                _context.directoryListing[i] = event.files[i];
            onComplete();
        }
    }
}