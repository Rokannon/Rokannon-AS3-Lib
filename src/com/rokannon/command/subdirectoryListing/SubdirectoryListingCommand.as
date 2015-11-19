package com.rokannon.command.subdirectoryListing
{
    import com.rokannon.command.directoryListing.DirectoryListingCommand;
    import com.rokannon.command.directoryListing.DirectoryListingContext;
    import com.rokannon.core.command.MethodCommand;
    import com.rokannon.core.command.SequenceCommand;

    import flash.filesystem.File;

    public class SubdirectoryListingCommand extends SequenceCommand
    {
        private const _directoryListingContext:DirectoryListingContext = new DirectoryListingContext();
        private const _subdirectoriesListingCommand:SequenceCommand = new SequenceCommand();
        private const _subdirectoriesListingContexts:Vector.<SubdirectoryListingContext> = new <SubdirectoryListingContext>[];

        private var _context:SubdirectoryListingContext;

        public function SubdirectoryListingCommand(context:SubdirectoryListingContext)
        {
            super();
            _context = context;
            _directoryListingContext.directoryToLoad = _context.directoryToLoad;
            addCommand(new DirectoryListingCommand(_directoryListingContext));
            addCommand(new MethodCommand(handleDirectoryListing, null));
            addCommand(_subdirectoriesListingCommand);
            addCommand(new MethodCommand(handleSubdirectories, null));
        }

        private function handleDirectoryListing():Boolean
        {
            for (var i:int = 0; i < _directoryListingContext.directoryListing.length; ++i)
            {
                var file:File = _directoryListingContext.directoryListing[i];
                    _context.directoryListing.push(file);
                if (file.isDirectory)
                {
                    var subdirectoryListingContext:SubdirectoryListingContext = new SubdirectoryListingContext();
                    _subdirectoriesListingContexts.push(subdirectoryListingContext);
                    subdirectoryListingContext.directoryToLoad = file;
                    _subdirectoriesListingCommand.addCommand(new SubdirectoryListingCommand(subdirectoryListingContext));
                }
            }
            return true;
        }

        private function handleSubdirectories():Boolean
        {
            for (var i:int = 0; i < _subdirectoriesListingContexts.length; ++i)
            {
                var subdirectoryListingContext:SubdirectoryListingContext = _subdirectoriesListingContexts[i];
                for (var j:int = 0; j < subdirectoryListingContext.directoryListing.length; ++j)
                    _context.directoryListing.push(subdirectoryListingContext.directoryListing[j]);
            }
            return true;
        }
    }
}