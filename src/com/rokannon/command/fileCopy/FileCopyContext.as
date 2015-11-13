package com.rokannon.command.fileCopy
{
    import flash.filesystem.File;

    public class FileCopyContext
    {
        public var fileToCopy:File;
        public var directoryToCopyTo:File;
        public var newFileName:String;
        public var overwrite:Boolean;

        public function FileCopyContext()
        {
        }
    }
}