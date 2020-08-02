package {
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;

	public class Polygon {
		private var corners:Vector.<Number3D> = new Vector.<Number3D>();
		public var polyPlane:Plane3D;
		public var polyNormal:Number3D;
		public var midPoint:Number3D;
		
		public function Polygon(param:Vector.<Number3D>) {
			setCorners(param);
		}
		
		public function getCorners():Vector.<Number3D> {
			return corners;
		}
		
		public function setCorners(newCorners:Vector.<Number3D>):void {
			corners=newCorners;
			polyPlane = Plane3D.fromThreePoints(corners[0],corners[1],corners[2]);
			polyNormal = polyPlane.normal;
			midPoint = Number3D.ZERO.clone();
			for(var i:int=0; i<corners.length; i++) {
				midPoint.plusEq(corners[i]);
			}
			midPoint.multiplyEq(1/corners.length);
		}
		
		public function shrink():void {
			const factor:int=20;
			var newCorners:Vector.<Number3D> = new Vector.<Number3D>();
			var i:int;
			// the next few lines should already be there because of the constructor
			// however, it does not work without them
			// TODO - delete these lines
			// we should not set corners directly, but calculate mid there
			// see planeCut and cornerColor
			midPoint = Number3D.ZERO.clone();
			for(i=0; i<corners.length; i++) {
				midPoint.plusEq(corners[i]);
			}
			midPoint.multiplyEq(1/corners.length);
			// end deletion
			for(i=0; i<corners.length; i++) {
				var newCorner:Number3D = corners[i].clone();
				newCorner.multiplyEq(factor);
				newCorner.plusEq(midPoint);
				newCorner.multiplyEq(1/(1+factor));
				newCorners.push(newCorner);
			}
			setCorners(newCorners);
		}
		
		public function planeCut(cutPlane:Rotation):Polygon {
			var pointsBelow:Vector.<Number3D> = new Vector.<Number3D>();
			var pointsAbove:Vector.<Number3D> = new Vector.<Number3D>();
			
			var newPoint:Number3D;
			
			for(var i:int=0; i<corners.length; i++) {
				var nextidx:int =(i+1)%corners.length; 
				if(cutPlane.distance(corners[i]) > BasisShape3D.epsilon) {
					pointsAbove.push(corners[i]);
					if(cutPlane.distance(corners[nextidx]) < -BasisShape3D.epsilon) {
						newPoint = MyUtils.getIntersectionLineNumbers(cutPlane,corners[i],corners[nextidx]);
						pointsAbove.push(newPoint);
						pointsBelow.push(newPoint);
					}
				}
				else if(cutPlane.distance(corners[i]) < -BasisShape3D.epsilon) {
					pointsBelow.push(corners[i]);
					if(cutPlane.distance(corners[nextidx]) > BasisShape3D.epsilon) {
						newPoint = MyUtils.getIntersectionLineNumbers(cutPlane,corners[i],corners[nextidx]);
						pointsAbove.push(newPoint);
						pointsBelow.push(newPoint);
					}
				}
				else {
					pointsAbove.push(corners[i]);
					pointsBelow.push(corners[i]);
				}
			}
			
			if(pointsAbove.length<=2 || pointsBelow.length<=2) return null;
			//trace("have points: " + corners.length.toString());
			//trace("have points above: " + pointsAbove.length.toString());
			//trace("have points below: " + pointsBelow.length.toString());
			//trace("my old points = " + toString());
			setCorners(pointsAbove);
			//trace("my new points = " + toString());
			return new Polygon(pointsBelow);
		}

		public function toString():String {
			var local:String = "polygon:";
			for(var i:int=0; i<corners.length; i++) {
				local += " -- " + corners[i].toString();
			}
			return local;
		}
	}
}