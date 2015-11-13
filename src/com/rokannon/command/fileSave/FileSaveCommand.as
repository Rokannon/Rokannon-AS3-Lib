package com.rokannon.command.fileSave
{
    import com.rokannon.core.command.CommandBase;
    import com.rokannon.logging.Log;
    import com.rokannon.logging.Logger;

    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    public class FileSaveCommand extends CommandBase
    {
        private static const logger:Logger = Log.instance.getLogger(FileSaveCommand);

        private const _fileStream:FileStream = new FileStream();

        private var _context:FileSaveContext;

        public function FileSaveCommand(context:FileSaveContext)
        {
            super();
            _context = context;
        }

        override protected function onStart():void
        {
            var fileMode:String = _context.appendMode ? FileMode.APPEND : FileMode.WRITE;
            try
            {
                _fileStream.open(_context.fileToSaveTo, fileMode);
            }
            catch (error:Error)
            {
                CONFIG::log_error
                {
                    logger.error("Failed to open file: {0}", _context.fileToSaveTo.nativePath);
                }
                onFailed();
            }
            try
            {
                _context.bytesToWrite.position = 0;
                _fileStream.writeBytes(_context.bytesToWrite, 0, _context.bytesToWrite.length);
                onComplete();
            }
            catch (error:Error)
            {
                CONFIG::log_error
                {
                    logger.error("Failed to write data to file: {0}", _context.fileToSaveTo.nativePath);
                }
                onFailed();
            }
            finally
            {
                _fileStream.close();
            }
        }
    }
}