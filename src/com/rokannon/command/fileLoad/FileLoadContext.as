package com.rokannon.command.fileLoad
{
    import flash.filesystem.File;
    import flash.utils.ByteArray;

    public class FileLoadContext
    {
        public var fileToLoad:File;
        public var fileContent:ByteArray;

        public function FileLoadContext()
        {
        }
    }
}