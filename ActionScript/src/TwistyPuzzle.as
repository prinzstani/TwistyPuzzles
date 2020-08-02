package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.papervision3d.core.log.PaperLogger;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.objects.DisplayObject3D;

	public class TwistyPuzzle extends DisplayObject3D {
		public static var activeTwisty:TwistyPuzzle=null;
		private var sideCount:int;
		private var cornerCount:int;
		private var cornersPerSide:int;
		private var sidesPerCorner:int;
		private var adjacentCorners:Vector.<Number3D> = new Vector.<Number3D>();
		public var myparent:Sprite;
		public var inProgress:Boolean=false;
		private var myPosition:Number3D;
		public var myTransform:Matrix3D = new Matrix3D();
		private var baseShape:BasisShape3D;
		private var cutting:Cutting3D;
		public var rotations:Vector.<Rotation> = new Vector.<Rotation>();
		public var polygons:Vector.<Polygon3D> = new Vector.<Polygon3D>();
		
		public function TwistyPuzzle(myParent:Sprite, myShape:BasisShape3D, myCut:Cutting3D, miniPosition:Number3D) {
			myparent=myParent;
			position=myPosition=miniPosition;
			if(!TwistyPuzzle.activeTwisty) setActive();
			baseShape=myShape;
			sideCount=baseShape.sides.length;
			cornerCount=baseShape.corners.length;
			cornersPerSide=baseShape.sides[0].getCorners().length;
			sidesPerCorner = cornersPerSide*sideCount/cornerCount;
			for (var i:int=0; i<cornerCount; i++) {
				adjacentCorners.push(findAdjacentCorner(baseShape.corners[i]));
			}
			cutting=myCut;
			baseShape.handleColoring();
			if(cutting.cutSide) {
				createSideCutPlanes(cutting.ratio);
			} else {
				createCornerCutPlanes(cutting.ratio);
			}
			trace("have created " + rotations.length.toString() + " cut planes.");
			createMiniShapes();
			createRotations();
		}
		
		public function setActive():void {
			TwistyPuzzle.activeTwisty=this;
			transform = myTransform;
		}
		
		public function setInactive():void {
			myTransform = transform;
			transform=new Matrix3D();
			position=myPosition;
		}
		
		public function createMiniShapes():void {
			for(var i:int = 0; i<baseShape.sides.length; i++) {
				createSideMiniShapes(baseShape.sides[i],baseShape.myColoring.materials[i]);
			}
		}
		
		private function createSideMiniShapes(poly:Polygon, material:MaterialObject3D):void {
			var miniShapes:Vector.<Polygon>=new Vector.<Polygon>();
			var tempShape:Polygon;
			var i:int;
			var j:int;
			
			miniShapes.push(new Polygon(poly.getCorners()));
			for(i = 0; i<rotations.length; i++) {
				//trace("### rotation No " + (i+1).toString());
				var ll:int = miniShapes.length;
				//trace("### count shapes " + ll.toString());
				for(j = 0; j<ll; j++) {
					if((tempShape=miniShapes[j].planeCut(rotations[i]))!=null) {
						miniShapes.push(tempShape);
					}
				}
			}
			for(i = 0; i<miniShapes.length; i++) {
				miniShapes[i].shrink();
				var polygon:Polygon3D = new Polygon3D(this,material,miniShapes[i]);
				insertPolygon(polygon);
			}
		}
		
		private function insertPolygon(poly:Polygon3D):void {
			addChild(poly);
			polygons.push(poly);
		}
		
		private function foundParallelSide(num:int):Boolean {
			for (var i:int=0; i<num; i++) {
				var theCross:Number3D = 
					Number3D.cross(baseShape.sides[num].polyNormal,baseShape.sides[i].polyNormal);
				if (theCross.modulo < BasisShape3D.epsilon) {
					return true;
				}
			}
			return false;
		}
		
		private function foundOppositePoint(num:int):Boolean {
			for (var i:int=0; i<num; i++) {
				if (Number3D.sub(baseShape.corners[num],baseShape.corners[i]).
					isModuloLessThan(BasisShape3D.epsilon)) 
					return true;
			}
			return false;
		}
		
		public function createRotations():void {
			var rotationShapes:Vector.<Polygon3D>;
			for (var i:int=0; i<rotations.length; i++) {
				rotationShapes = new Vector.<Polygon3D>();
				for (var j:int=0; j<polygons.length; j++) {
					if(rotations[i].isMyPoint(polygons[j].midPoint)) {
						rotationShapes.push(polygons[j]);
						polygons[j].myRotations.push(rotations[i]);
					}
				}
				rotations[i].polygons=rotationShapes;
				//trace("updated a rotation: " + rotations[i].toString());
			}
		}
		
		public function createCornerCutPlanes(ratio:Number):void {
			for (var i:int=0; i<baseShape.corners.length; i++) {
				if(ratio || !foundOppositePoint(i)) {
					// trace("createCornerPlanes for " + baseShape.corners[i].toString());
					var currentCorner:Number3D=baseShape.corners[i];
					var theNormal:Number3D=currentCorner.clone();
					theNormal.normalize();;
					// the current corner is also the direction, since the middle is (0,0,0) 
					var inverseNormal:Number3D=Number3D.sub(Number3D.ZERO,theNormal);
					var adjacentCorner:Number3D=adjacentCorners[i];
					var currentMid:Number3D;
					if (ratio==0) {
						currentMid=Number3D.ZERO;
						trace("created a zero corner cut plane at " + i.toString() + " and " + count.toString());
						rotations.push(new Rotation(theNormal,currentMid,currentCorner,sidesPerCorner));
						rotations.push(new Rotation(inverseNormal,currentCorner,currentMid,sidesPerCorner));
					}
					var lastPoint:Number3D=currentCorner;
					for (var count:int=1; count<=ratio; count++) {
						currentMid=MyUtils.scalePoints(currentCorner,adjacentCorner,count,cutting.ratio-count);
						trace("created a corner cut plane at " + i.toString() + " and " + count.toString());
						rotations.push(new Rotation(theNormal,currentMid,lastPoint,sidesPerCorner));
						rotations.push(new Rotation(inverseNormal,lastPoint,currentMid,sidesPerCorner));
						lastPoint=currentMid;
					}
				}
			}
		}

		public function createSideCutPlanes(ratio:Number):void {
			var rotationAngle:int = baseShape.sides[0].getCorners().length;
			for (var i:int=0; i<baseShape.sides.length; i++) {
				if(!baseShape.isSimple() || !foundParallelSide(i)) {
//					trace("createPlanes for " + baseShape.sides[i].toString());
					var currentSide:Polygon=baseShape.sides[i];
					var point1:Number3D = currentSide.getCorners()[0];
					var point2:Number3D = currentSide.getCorners()[1];
					var adjacentPoint:Number3D=findAdjacentPoint(currentSide,point1,point2);
					var lastPoint:Number3D=null;
					for (var count:int=1; count<ratio; count++) {
						var theNormal:Number3D=currentSide.polyNormal;
						var inverseNormal:Number3D=Number3D.sub(Number3D.ZERO,theNormal);
						var currentMid:Number3D=MyUtils.scalePoints(point1,adjacentPoint,count,cutting.ratio-count);
						var outside1:Number3D=MyUtils.scalePoints(point1,adjacentPoint,-1,101);
						var outside2:Number3D=MyUtils.scalePoints(point1,adjacentPoint,101,-1);
						if(lastPoint) {
							trace("created a last point cut plane at " + i.toString() + " and " + count.toString());
							rotations.push(new Rotation(theNormal,currentMid,lastPoint,rotationAngle));
							rotations.push(new Rotation(inverseNormal,lastPoint,currentMid,rotationAngle));
						}
						if(count==1) {
							trace("created a first cut plane at " + i.toString() + " and " + count.toString());
							rotations.push(new Rotation(theNormal,currentMid,outside1,rotationAngle));
							rotations.push(new Rotation(inverseNormal,outside1,currentMid,rotationAngle));
						}
						if((rotationAngle<=4) && (count+1==cutting.ratio)) {
							trace("created a last cut plane at " + i.toString() + " and " + count.toString());
							rotations.push(new Rotation(theNormal,outside2,currentMid,rotationAngle));
							rotations.push(new Rotation(inverseNormal,currentMid,outside2,rotationAngle));
						}
						lastPoint=currentMid;
					}
				}
			}
		}
		
		private function findAdjacentPoint(side:Polygon,point1:Number3D,point2:Number3D):Number3D {
			for (var i:int=0; i<baseShape.sides.length; i++) {
				var currentSide:Polygon = baseShape.sides[i];
				if(currentSide!=side) {
					var idx:int=currentSide.getCorners().indexOf(point1);
					var len:int=currentSide.getCorners().length;
					if(idx != -1) {
						var idx2:int = (idx+1)%len;
						var idx3:int = (idx+len-1)%len;
						if(point2 == currentSide.getCorners()[idx2]) {
							return currentSide.getCorners()[idx3];
						}
						if(point2 == currentSide.getCorners()[idx3]) {
							return currentSide.getCorners()[idx2];
						}
					}
				}
			}
			PaperLogger.error( "Did not find adjacent point!");
			return null;
		}

		private function findAdjacentCorner(corner:Number3D):Number3D {
			for (var i:int=0; i<baseShape.sides.length; i++) {
				var currentSide:Polygon = baseShape.sides[i];
				var idx:int=currentSide.getCorners().indexOf(corner);
				var len:int=currentSide.getCorners().length;
				if(idx != -1) {
					var idx2:int = (idx+1)%len;
					return currentSide.getCorners()[idx2];
				}
			}
			PaperLogger.error( "Did not find adjacent point!");
			return null;
		}
	}
}