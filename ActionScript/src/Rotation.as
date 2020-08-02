package {
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;

	public class Rotation extends Plane3D {
		public var previousPlane:Plane3D=null;
		public var thePoint:Number3D;
		public var secondPoint:Number3D;
		public var angle:int; //how often do you need to take the rotation until you reach nothing
		public var polygons:Vector.<Polygon3D> = new Vector.<Polygon3D>();
		
		public function Rotation(axis:Number3D, point:Number3D, second:Number3D, myangle:int) {
			super(axis,point);
			angle=myangle;
			thePoint=point;
			secondPoint=second;
			previousPlane = new Plane3D(axis,second);
		}
		
		public function isMyPoint(point:Number3D):Boolean {
			var dist1:Number = distance(point); 
			var dist2:Number = previousPlane.distance(point); 
			return ((dist1 > 0) && (dist2 < 0));
		}
		
		public override function toString():String {
			var local:String = "cutPlane: " + super.toString();
			if (previousPlane) local += " previous is " + previousPlane.toString();
			local += " points: " + thePoint.toString() + " and " + secondPoint.toString();
			local += " angle: " + angle;
			local += " midpoints of " + polygons.length.toString() + " polys: ";
			for (var i:int=0; i<polygons.length; i++) {
				local += polygons[i].midPoint.toString();
			}
			local += "#";
			return local;
		}
	}
}