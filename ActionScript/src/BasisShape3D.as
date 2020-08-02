package {
	import org.papervision3d.core.log.PaperLogger;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	
	public class BasisShape3D {
		public var corners:Vector.<Number3D> = new Vector.<Number3D>();
		public var sides:Vector.<Polygon> = new Vector.<Polygon>();
		private var cornersPerSide:Number;

		protected const white:MaterialObject3D  = MyUtils.createColor(0xFFFFFF);
		protected const yellow:MaterialObject3D = MyUtils.createColor(0xFFFF00);
		protected const orange:MaterialObject3D = MyUtils.createColor(0xFF9900);
		protected const red:MaterialObject3D    = MyUtils.createColor(0xD80505);
		protected const green:MaterialObject3D  = MyUtils.createColor(0x1CA91B);
		protected const blue:MaterialObject3D   = MyUtils.createColor(0x0018EE);
		protected const gold:MaterialObject3D   = MyUtils.createColor(0x8B7500);
		protected const brown:MaterialObject3D  = MyUtils.createColor(0x8B4513);

		public var myColoring:Coloring3D;

		public static const scale:Number = 20;
		public static const epsilon:Number = scale/1000;
		
		public function isSimple():Boolean {
			return sides.length < 10;
		}

		public function handleColoring():void {
			var i:int; 
			if(myColoring.sideColoring) {
				if(myColoring.materials.length != sides.length)
					PaperLogger.error( "Number of colors does not match number of sides");
				return;
			}
			if(myColoring.materials.length != corners.length)
				PaperLogger.error( "Number of colors does not match number of corners");
			var sideColors:Vector.<MaterialObject3D> = new Vector.<MaterialObject3D>();
			cornersPerSide=sides[0].getCorners().length;
			var sideCount:int = sides.length;
			for(i = 0; i<sideCount; i++) {
				createSideColorShapes(sides[i]);
			}
			for(i = 0; i<sides.length; i++) {
				var currentCornerIndex:Number=corners.indexOf(sides[i].getCorners()[0]);
				sideColors.push(myColoring.materials[currentCornerIndex]);
			}
			myColoring.sideColoring=true;
			myColoring.materials=sideColors;
		}
		
		private function createSideColorShapes(poly:Polygon):void {
			var middlePoints:Vector.<Number3D>=new Vector.<Number3D>();
			var tempShape:Polygon;
			var tempPoint:Number3D;
			var tempPoints:Vector.<Number3D>;
			var i:int;
			var j:int;

			for(i = 0; i<cornersPerSide-1; i++) {
				tempPoint=poly.getCorners()[i].clone();
				tempPoint.plusEq(poly.getCorners()[i+1]);
				tempPoint.multiplyEq(0.5);
				middlePoints.push(tempPoint);
			}
			tempPoint=poly.getCorners()[cornersPerSide-1].clone();
			tempPoint.plusEq(poly.getCorners()[0]);
			tempPoint.multiplyEq(0.5);
			middlePoints.push(tempPoint);

			for(i = 1; i<cornersPerSide; i++) {
				tempPoints = new Vector.<Number3D>();
				tempPoints.push(poly.getCorners()[i],middlePoints[i],poly.midPoint,middlePoints[i-1]);
				sides.push(new Polygon(tempPoints));
			}
			//var oldCorner=poly.getCorners[0].clone();
			tempPoints = new Vector.<Number3D>();
			tempPoints.push(poly.getCorners()[0],middlePoints[0],poly.midPoint,middlePoints[cornersPerSide-1]);
			poly.setCorners(tempPoints);
			//poly.getCorners.push(oldCorner,middlePoints[0],poly.midPoint,middlePoints[cornersPerSide-1]);
		}
	}
}	
