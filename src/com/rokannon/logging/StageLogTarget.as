package com.rokannon.logging
{
    import com.rokannon.logging.enum.LogLevel;

    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.TimerEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.utils.Timer;

    public class StageLogTarget extends LogTarget
    {
        private static const REMOVE_DELAY:int = 1000;
        private static const MAX_MESSAGES:int = 15;

        private var _stage:Stage;

        private const _logContainer:Sprite = new Sprite();
        private const _removeTimer:Timer = new Timer(REMOVE_DELAY);
        private const _messageTextFields:Vector.<TextField> = new <TextField>[];
        private const _messageFormat:TextFormat = new TextFormat(null, null, 0xFFFFFF);

        public function StageLogTarget(stage:Stage)
        {
            super();
            _stage = stage;
            updateLogContainer();
            _removeTimer.addEventListener(TimerEvent.TIMER, onRemoveTimer);
        }

        override protected function log(loggerName:String, logLevel:uint, message:String):void
        {
            updateLogContainer();
            addMessage(loggerName, logLevel, message);
            if (_messageTextFields.length > MAX_MESSAGES)
            {
                _logContainer.removeChild(_messageTextFields.shift());
            }
            arrangeTextFields();
            if (logLevel == LogLevel.FATAL)
                _removeTimer.stop();
            else if (_messageTextFields.length == 1)
                startRemoveTimer();
        }

        private function addMessage(loggerName:String, logLevel:uint, message:String):void
        {
            var textField:TextField = new TextField();
            textField.background = true;
            textField.backgroundColor = logLevel == LogLevel.FATAL ? 0xCC2222 : 0x000000;
            textField.defaultTextFormat = _messageFormat;
            textField.text = "[" + LogLevel.toString(logLevel) + "] [" + loggerName + "] " + message;
            textField.width = 1024;
            textField.height = 4 + textField.textHeight;
            textField.wordWrap = true;
            textField.selectable = false;
            textField.autoSize = TextFieldAutoSize.LEFT;
            _messageTextFields.push(textField);
            _logContainer.addChild(textField);
        }

        private function updateLogContainer():void
        {
            _stage.addChild(_logContainer);
        }

        private function startRemoveTimer():void
        {
            _removeTimer.reset();
            _removeTimer.start();
        }

        private function onRemoveTimer(event:TimerEvent):void
        {
            if (_messageTextFields.length == 0)
                _removeTimer.stop();
            else
            {
                _logContainer.removeChild(_messageTextFields.shift());
                arrangeTextFields();
            }
        }

        private function arrangeTextFields():void
        {
            var yOffset:Number = 0;
            for (var i:int = 0; i < _messageTextFields.length; ++i)
            {
                _messageTextFields[i].x = 0;
                _messageTextFields[i].y = yOffset;
                yOffset += _messageTextFields[i].textHeight + 6;
            }
        }
    }
}