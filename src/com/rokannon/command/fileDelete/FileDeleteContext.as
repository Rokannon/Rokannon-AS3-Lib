package com.rokannon.command.fileDelete
{
    import flash.filesystem.File;

    public class FileDeleteContext
    {
        public var fileToDelete:File;
        public var failOnError:Boolean = true;

        public function FileDeleteContext()
        {
        }
    }
}