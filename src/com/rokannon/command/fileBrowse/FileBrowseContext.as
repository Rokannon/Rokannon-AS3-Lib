package com.rokannon.command.fileBrowse
{
    import flash.filesystem.File;

    public class FileBrowseContext
    {
        public var fileToBrowse:File;
        public var failOnCancel:Boolean = true;
        public var browseTitle:String = "Browse";
        public var typeFilter:Array;

        public function FileBrowseContext()
        {
        }
    }
}