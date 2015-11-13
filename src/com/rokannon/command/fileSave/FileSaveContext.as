package com.rokannon.command.fileSave
{
    import flash.filesystem.File;
    import flash.utils.ByteArray;

    public class FileSaveContext
    {
        public var fileToSaveTo:File;
        public var bytesToWrite:ByteArray;
        public var appendMode:Boolean;

        public function FileSaveContext()
        {
        }
    }
}