package com.rokannon.math.geom
{
    import com.rokannon.core.pool.IPoolObject;
    import com.rokannon.core.utils.getProperty;
    import com.rokannon.display.render.IRenderTarget;
    import com.rokannon.display.render.IRenderable;
    import com.rokannon.logging.Log;
    import com.rokannon.logging.Logger;
    import com.rokannon.math.utils.getMax;
    import com.rokannon.math.utils.getMin;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class AABBox implements IRenderable, IPoolObject
    {
        private static const logger:Logger = Log.instance.getLogger(AABBox);
        private static const helperSegment:Segment = new Segment();
        private static const helperVertices:Vector.<Number> = new <Number>[];
        private static const helperPoint:Point = new Point();

        private static const INSIDE:int = 0;
        private static const LEFT:int = 1;
        private static const RIGHT:int = 2;
        private static const BOTTOM:int = 4;
        private static const TOP:int = 8;

        private var _xMin:Number;
        private var _yMin:Number;
        private var _xMax:Number;
        private var _yMax:Number;

        public function AABBox(xMin:Number = 0, yMin:Number = 0, xMax:Number = 0, yMax:Number = 0)
        {
            setTo(xMin, yMin, xMax, yMax);
        }

        public function get xMin():Number
        {
            return _xMin;
        }

        public function get yMin():Number
        {
            return _yMin;
        }

        public function get xMax():Number
        {
            return _xMax;
        }

        public function get yMax():Number
        {
            return _yMax;
        }

        public function setTo(xMin:Number, yMin:Number, xMax:Number, yMax:Number):void
        {
            _xMin = xMin;
            _yMin = yMin;
            _xMax = xMax;
            _yMax = yMax;

            CONFIG::log_fatal
            {
                if (_xMax < _xMin || _yMax < _yMin)
                    logger.fatal("Invalid box bounds: {0}", this.toString());
            }
        }

        /** 0 to 3 */
        public function getVertex(index:int, resultPoint:Point = null):Point
        {
            resultPoint ||= new Point();
            index = index & 3;
            resultPoint.setTo((((index + 1) & 3) >> 1) == 0 ? _xMin : _xMax, (index >> 1) == 0 ? _yMin : _yMax);
            return resultPoint;
        }

        /** 0 to 3 */
        public function getSide(index:int, resultSegment:Segment = null):Segment
        {
            resultSegment ||= new Segment();
            index = index & 3;
            resultSegment.setTo(((index & 1) ^ (index >> 1)) == 0 ? _xMin : _xMax, (index >> 1) == 0 ? _yMin : _yMax,
                ((index ^ 2) >> 1) == 0 ? _xMin : _xMax, ((index & 1) ^ (index >> 1)) == 0 ? _yMin : _yMax);
            return resultSegment;
        }

        public function copyFromBox(box:AABBox):void
        {
            setTo(box._xMin, box._yMin, box._xMax, box._yMax);
        }

        public function copyFromRectange(rectange:Rectangle):void
        {
            setTo(rectange.x, rectange.y, rectange.x + rectange.width, rectange.y + rectange.height);
        }

        public function toRectangle(resultRectangle:Rectangle = null):Rectangle
        {
            resultRectangle ||= new Rectangle();
            resultRectangle.setTo(_xMin, _yMin, _xMax - _xMin, _yMax - _yMin);
            return resultRectangle;
        }

        public function toPolygon(resultPolygon:PolygonShape = null):PolygonShape
        {
            for (var i:int = 0; i < 4; ++i)
            {
                getVertex(i, helperPoint);
                helperVertices[i << 1] = helperPoint.x;
                helperVertices[(i << 1) + 1] = helperPoint.y;
            }
            resultPolygon ||= new PolygonShape();
            resultPolygon.setTo(helperVertices);
            helperVertices.length = 0;
            return resultPolygon;
        }

        public function union(box:AABBox, resultBox:AABBox = null):AABBox
        {
            resultBox ||= new AABBox();
            resultBox.setTo(getMin(_xMin, box._xMin), getMin(_yMin, box._yMin), getMax(_xMax, box._xMax),
                getMax(_yMax, box._yMax));
            return resultBox;
        }

        public function intersectsBox(box:AABBox):Boolean
        {
            return _xMax >= box._xMin && box._xMax >= _xMin && _yMax >= box._yMin && box._yMax >= _yMin;

        }

        public function inflate(dx:Number, dy:Number):void
        {
            _xMin -= dx;
            _yMin -= dy;
            _xMax += dx;
            _yMax += dy;
        }

        public function inflateToXY(x:Number, y:Number):void
        {
            _xMin = getMin(_xMin, x);
            _yMin = getMin(_yMin, y);
            _xMax = getMax(_xMax, x);
            _yMax = getMax(_yMax, y);
        }

        public function inflateToP(point:Point):void
        {
            _xMin = getMin(_xMin, point.x);
            _yMin = getMin(_yMin, point.y);
            _xMax = getMax(_xMax, point.x);
            _yMax = getMax(_yMax, point.y);
        }

        public function intersectsShape(shape:IShape):Boolean
        {
            if (shape.containsXY(0.5 * (_xMin + _xMax), 0.5 * (_yMin + _yMax)))
                return true;
            for (var i:int = 0; i < 4; ++i)
            {
                getSide(i, helperSegment);
                if (shape.intersectsSegment(helperSegment))
                    return true;
            }
            return false;
        }

        [Inline]
        private final function getOutCode(x:Number, y:Number):int
        {
            var code:int = INSIDE;
            if (x < _xMin)
                code |= LEFT;
            else if (x > _xMax)
                code |= RIGHT;
            if (y < _yMin)
                code |= BOTTOM;
            else if (y > _yMax)
                code |= TOP;
            return code;
        }

        public function toString():String
        {
            var object:Object = {
                xMin: _xMin, yMin: _yMin, xMax: _xMax, yMax: _yMax
            };
            return JSON.stringify(object);
        }

        public function closestPointToXY(x:Number, y:Number, resultPoint:Point = null):Point
        {
            resultPoint ||= new Point();
            if (x < _xMin)
            {
                if (y < _yMin)
                    resultPoint.setTo(_xMin, _yMin);
                else if (y < _yMax)
                    resultPoint.setTo(_xMin, y);
                else
                    resultPoint.setTo(_xMin, _yMax);
            }
            else if (x < _xMax)
            {
                if (y < _yMin)
                    resultPoint.setTo(x, _yMin);
                else if (y < _yMax)
                {
                    // Point is inside of box.
                    var d:Number;
                    if (_xMax - _xMin > _yMax - _yMin)
                    {
                        d = getMin(y - _yMin, _yMax - y);
                        if (x - _xMin < d)
                            resultPoint.setTo(_xMin, y);
                        else if (_xMax - x < d)
                            resultPoint.setTo(_xMax, y);
                        else if (y < 0.5 * (_yMin + _yMax))
                            resultPoint.setTo(x, _yMin);
                        else
                            resultPoint.setTo(x, _yMax);
                    }
                    else
                    {
                        d = getMin(x - _xMin, _xMax - x);
                        if (y - _yMin < d)
                            resultPoint.setTo(x, _yMin);
                        else if (_yMax - y < d)
                            resultPoint.setTo(x, _yMax);
                        else if (x < 0.5 * (_xMin + _xMax))
                            resultPoint.setTo(_xMin, y);
                        else
                            resultPoint.setTo(_xMax, y);
                    }
                }
                else
                    resultPoint.setTo(x, _yMax);
            }
            else
            {
                if (y < _yMin)
                    resultPoint.setTo(_xMax, _yMin);
                else if (y < _yMax)
                    resultPoint.setTo(_xMax, y);
                else
                    resultPoint.setTo(_xMax, _yMax);
            }
            return resultPoint;
        }

        public function closestPointToP(point:Point, resultPoint:Point = null):Point
        {
            return closestPointToXY(point.x, point.y, resultPoint);
        }

        public function containsXY(x:Number, y:Number):Boolean
        {
            return _xMin <= x && x <= _xMax && _yMin <= y && y <= _yMax;
        }

        public function containsP(point:Point):Boolean
        {
            return _xMin <= point.x && point.x <= _xMax && _yMin <= point.y && point.y <= _yMax;
        }

        /**
         * Cohen–Sutherland algorithm.
         */
        public function intersectsSegment(segment:Segment):Boolean
        {
            var x0:Number = segment.x1;
            var y0:Number = segment.y1;
            var x1:Number = segment.x2;
            var y1:Number = segment.y2;

            var outcode0:int = getOutCode(x0, y0);
            var outcode1:int = getOutCode(x1, y1);
            var intersects:Boolean;

            while (true)
            {
                if ((outcode0 | outcode1) == 0)
                {
                    intersects = true;
                    break;
                }
                else if ((outcode0 & outcode1) != 0)
                    break;
                else
                {
                    var outcodeOut:int = outcode0 != 0 ? outcode0 : outcode1;
                    var x:Number;
                    var y:Number;

                    if (outcodeOut & TOP)
                    {
                        x = x0 + (x1 - x0) * (_yMax - y0) / (y1 - y0);
                        y = _yMax;
                    }
                    else if (outcodeOut & BOTTOM)
                    {
                        x = x0 + (x1 - x0) * (_yMin - y0) / (y1 - y0);
                        y = _yMin;
                    }
                    else if (outcodeOut & RIGHT)
                    {
                        y = y0 + (y1 - y0) * (_xMax - x0) / (x1 - x0);
                        x = _xMax;
                    }
                    else if (outcodeOut & LEFT)
                    {
                        y = y0 + (y1 - y0) * (_xMin - x0) / (x1 - x0);
                        x = _xMin;
                    }

                    if (outcodeOut == outcode0)
                    {
                        x0 = x;
                        y0 = y;
                        outcode0 = getOutCode(x0, y0);
                    }
                    else
                    {
                        x1 = x;
                        y1 = y;
                        outcode1 = getOutCode(x1, y1);
                    }
                }
            }
            return intersects;
        }

        public function offsetXY(dx:Number, dy:Number):void
        {
            _xMin += dx;
            _yMin += dy;
            _xMax += dx;
            _yMax += dy;
        }

        public function offsetP(point:Point):void
        {
            _xMin += point.x;
            _yMin += point.y;
            _xMax += point.x;
            _yMax += point.y;
        }

        public function render(renderTarget:IRenderTarget, renderSettings:Object):void
        {
            var color:uint = getProperty(renderSettings, "color", 0x000000);
            var filled:Boolean = getProperty(renderSettings, "filled", false);
            var offset:Number = getProperty(renderSettings, "offset", 0);

            helperVertices.push(_xMin - offset, _yMin - offset);
            helperVertices.push(_xMin - offset, _yMax + offset);
            helperVertices.push(_xMax + offset, _yMax + offset);
            helperVertices.push(_xMax + offset, _yMin - offset);

            if (filled)
                renderTarget.drawFilledPolygon(helperVertices, color);
            else
                renderTarget.drawPolygon(helperVertices, color);

            helperVertices.length = 0;
        }

        public function resetPoolObject():void
        {
            _xMin = 0;
            _yMin = 0;
            _xMax = 0;
            _yMax = 0;
        }
    }
}