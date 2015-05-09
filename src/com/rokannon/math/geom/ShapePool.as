package com.rokannon.math.geom
{
    import com.rokannon.core.errors.SingletonClassError;
    import com.rokannon.logging.Log;
    import com.rokannon.logging.Logger;

    public class ShapePool
    {
        public static const instance:ShapePool = new ShapePool();

        private static const logger:Logger = Log.instance.getLogger(ShapePool);

        private const _circleShapes:Vector.<CircleShape> = new Vector.<CircleShape>();
        private const _polygonShapes:Vector.<PolygonShape> = new Vector.<PolygonShape>();

        public function ShapePool()
        {
            if (instance != null)
                throw new SingletonClassError();
        }

        public function createCircleShape(x:Number = 0, y:Number = 0, radius:Number = 0):CircleShape
        {
            var circleShape:CircleShape;
            if (_circleShapes.length == 0)
                circleShape = new CircleShape(x, y, radius);
            else
            {
                circleShape = _circleShapes.pop();
                circleShape.setTo(x, y, radius);
            }
            return circleShape;
        }

        public function createPolygonShape(vertices:Vector.<Number> = null):PolygonShape
        {
            var polygonShape:PolygonShape;
            if (_polygonShapes.length == 0)
                polygonShape = new PolygonShape(vertices);
            else
            {
                polygonShape = _polygonShapes.pop();
                if (vertices != null)
                    polygonShape.setTo(vertices);
            }
            return polygonShape;
        }

        public function releaseShape(shape:IShape):void
        {
            switch (true)
            {
                case shape is CircleShape:
                    _circleShapes.push(shape as CircleShape);
                    break;
                case shape is PolygonShape:
                    _polygonShapes.push(shape as PolygonShape);
                    break;
                default:
                CONFIG::log_fatal
                {
                    logger.fatal("Unsupported shape: {0}", shape.toString());
                }
            }
        }
    }
}