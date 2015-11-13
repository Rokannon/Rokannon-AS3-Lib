package com.rokannon.command.fileCopy
{
    import com.rokannon.core.command.CommandBase;
    import com.rokannon.logging.Log;
    import com.rokannon.logging.Logger;

    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.filesystem.File;

    public class FileCopyCommand extends CommandBase
    {
        private static const logger:Logger = Log.instance.getLogger(FileCopyCommand);

        private var _context:FileCopyContext;

        public function FileCopyCommand(context:FileCopyContext)
        {
            super();
            _context = context;
        }

        override protected function onStart():void
        {
            var newFileName:String;
            if (_context.newFileName == null)
                newFileName = _context.fileToCopy.name;
            else
                newFileName = _context.newFileName;
            var newFile:File = _context.directoryToCopyTo.resolvePath(newFileName);
            _context.fileToCopy.addEventListener(Event.COMPLETE, onCopyComplete);
            _context.fileToCopy.addEventListener(IOErrorEvent.IO_ERROR, onCopyError);
            _context.fileToCopy.copyToAsync(newFile, _context.overwrite);
        }

        private function onCopyError(event:IOErrorEvent):void
        {
            _context.fileToCopy.removeEventListener(Event.COMPLETE, onCopyComplete);
            _context.fileToCopy.removeEventListener(IOErrorEvent.IO_ERROR, onCopyError);
            CONFIG::log_error
            {
                logger.error("Failed to copy file: {0}", _context.fileToCopy.nativePath);
            }
            onFailed();
        }

        private function onCopyComplete(event:Event):void
        {
            _context.fileToCopy.removeEventListener(Event.COMPLETE, onCopyComplete);
            _context.fileToCopy.removeEventListener(IOErrorEvent.IO_ERROR, onCopyError);
            onComplete();
        }
    }
}