package com.rokannon.core.command
{
    import flash.utils.Dictionary;

    public class CompositeCommand extends CommandBase
    {
        protected const _commands:Vector.<CommandBase> = new <CommandBase>[];

        private const _commandByName:Dictionary = new Dictionary();

        public function CompositeCommand()
        {
            super();
        }

        public function addCommand(command:CommandBase, name:String = null):CompositeCommand
        {
            _commands.push(command);
            if (name != null)
                _commandByName[name] = command;
            return this;
        }

        public function getCommandByName(name:String):CommandBase
        {
            return _commandByName[name];
        }
    }
}