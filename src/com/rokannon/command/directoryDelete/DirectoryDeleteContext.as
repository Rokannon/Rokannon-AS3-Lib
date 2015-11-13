package com.rokannon.command.directoryDelete
{
    import flash.filesystem.File;

    public class DirectoryDeleteContext
    {
        public var directoryToDelete:File;
        public var failOnError:Boolean = true;

        public function DirectoryDeleteContext()
        {
        }
    }
}