package com.rokannon.command.subdirectoryListing
{
    import flash.filesystem.File;

    public class SubdirectoryListingContext
    {
        public const directoryListing:Vector.<File> = new <File>[];

        public var directoryToLoad:File;

        public function SubdirectoryListingContext()
        {
        }
    }
}