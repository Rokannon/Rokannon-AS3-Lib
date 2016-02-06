package com.rokannon.command.fileBrowse
{
    import com.rokannon.core.command.CommandBase;

    import flash.events.Event;

    public class FileBrowseCommand extends CommandBase
    {
        private var _context:FileBrowseContext;

        public function FileBrowseCommand(context:FileBrowseContext)
        {
            super();
            _context = context;
        }

        override protected function onStart():void
        {
            _context.fileToBrowse.addEventListener(Event.SELECT, onBrowseSelected);
            _context.fileToBrowse.addEventListener(Event.CANCEL, onBrowseCancel);
            _context.fileToBrowse.browseForOpen(_context.browseTitle, _context.typeFilter);
        }

        private function onBrowseSelected(event:Event):void
        {
            _context.fileToBrowse.removeEventListener(Event.SELECT, onBrowseSelected);
            _context.fileToBrowse.removeEventListener(Event.CANCEL, onBrowseCancel);
            onComplete();
        }

        private function onBrowseCancel(event:Event):void
        {
            _context.fileToBrowse.removeEventListener(Event.SELECT, onBrowseSelected);
            _context.fileToBrowse.removeEventListener(Event.CANCEL, onBrowseCancel);
            if (_context.failOnCancel)
                onFailed();
            else
                onComplete();
        }
    }
}