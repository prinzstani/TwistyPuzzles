package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.papervision3d.Papervision3D;
	import org.papervision3d.core.geom.*;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Triangle3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.log.PaperLogger;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.NumberUV;
	import org.papervision3d.core.math.Plane3D;
	import org.papervision3d.core.proto.*;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.objects.DisplayObject3D;

	/**
	* The Polygon3D class lets you create and display flat polygons in 3D.
	*/
	public class Polygon3D extends TriangleMesh3D
	{
		/**
		* Number of segments per axis. Defaults to 1.
		*/
		private var myTwisty:TwistyPuzzle;
		public var corners:Vector.<Number3D>;
		public var midPoint:Number3D;
		public var transformedMidPoint:Number3D;
		public var polyPlane:Plane3D;
		public var mousedownPoint1:Point = new Point(); // mouse down point
		public var mousedownPoint:Point = new Point(); // mouse down point
		public var myRotations:Vector.<Rotation> = new Vector.<Rotation>();
		public var myCurrentRotations:Vector.<Rotation> = new Vector.<Rotation>();
		public var currentPolys:Vector.<Polygon3D>;
		private var currentRot:Rotation = null;
		private var rotationCount:Number;
		private const rotationMax:Number = 10;
		public static var tween:Sprite = new Sprite();
		private static var toRADIANS :Number = Math.PI/180;
		private var rotationMatrix:Matrix3D;
	
		/**
		* Create a new Polygon object.
		* <p/>
		* @param	material	A MaterialObject3D object that contains the material of the object.
		* <p/>
		* @param	corners		The vector of the points of the polygon. This is supposed to be convex.
		*/
		public function Polygon3D(twi:TwistyPuzzle, matParam:MaterialObject3D, polygon:Polygon) {
			var localMat:MaterialObject3D=matParam.clone();
			localMat.interactive=true;
			localMat.smooth=true;
			myTwisty=twi;
			super( localMat, new Array(), new Array(), null );
			corners = polygon.getCorners();
			transformedMidPoint = midPoint = polygon.midPoint;
			polyPlane = Plane3D.fromThreePoints(corners[0],corners[1],corners[2]);
			buildPolygon();
			addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, handlePress); 
		}
	
		private function handlePress(event:InteractiveScene3DEvent):void {
			if(TwistyPuzzle.activeTwisty.inProgress) return;
			if(myTwisty==TwistyPuzzle.activeTwisty) 
				onPolygonClicked(event);
			else {
				TwistyPuzzle.activeTwisty.setInactive();
				myTwisty.setActive();
			}
		}
		
		private function onPolygonClicked(event:InteractiveScene3DEvent):void {
//			trace("onPolygonClicked");
//			if(event) trace("event is " + event.toString());
//			if(event) trace("clicked on x " + event.x.toString() + " y " + event.y.toString());
			
//			trace("have clicked on " + this.midPoint.toString());
			addEventListener(InteractiveScene3DEvent.OBJECT_RELEASE, onPolygonReleased);
			addEventListener(InteractiveScene3DEvent.OBJECT_MOVE, onPolygonReleased);
			addEventListener(InteractiveScene3DEvent.OBJECT_OUT, onPolygonReleased);
			
			mousedownPoint1.x = event.x;
			mousedownPoint1.y = event.y;
			mousedownPoint.x = myTwisty.myparent.mouseX;
			mousedownPoint.y = myTwisty.myparent.mouseY;
//			trace("mouse clicked on x " + mousedownPoint.x.toString() + " y " + mousedownPoint.y.toString());
		}

		private function onPolygonReleased(event:InteractiveScene3DEvent):void {
			var dragPoint:Point = new Point();
			dragPoint.x = myTwisty.myparent.mouseX;
			dragPoint.y = myTwisty.myparent.mouseY;
			
			if(event.type != InteractiveScene3DEvent.OBJECT_OUT) // always handle OBJECT_OUT
				if(Point.distance(mousedownPoint, dragPoint) < 10) return; //do not handle small movements

			removeEventListener(InteractiveScene3DEvent.OBJECT_RELEASE, onPolygonReleased);
			removeEventListener(InteractiveScene3DEvent.OBJECT_MOVE, onPolygonReleased);
			removeEventListener(InteractiveScene3DEvent.OBJECT_OUT, onPolygonReleased);
			
			var n:Number3D = new Number3D(dragPoint.x - mousedownPoint.x, mousedownPoint.y - dragPoint.y, 0);
			//trace("mouse direction original to " + n.toString());
			//trace("rotation is X=" + rotationX.toString() + " Y= " + rotationY.toString() + " Z=" + rotationZ.toString());
//			trace("rotation is " + rot.toString());
			n = MyUtils.transformNumber(n, Matrix3D.inverse(myTwisty.transform));
			//trace("mouse direction after inverse " + n.toString());
			//trace("mouse direction after rot & inverse " + n.toString());
			//trace("my plane is " + polyPlane.toString());
			//trace("my plane direction is " + polyPlane.normal.toString());
			//var rotPolyNormal:Number3D = MyUtils.transformNumber(polyPlane.normal, Matrix3D.inverse(rot));
			var rotPolyNormal:Number3D = MyUtils.transformNumber(polyPlane.normal, transform);
			//trace("translated plane direction " + rotPolyNormal.toString());
			//var mouseOnPolygon:Number3D = Number3D.cross(Number3D.cross(polyPlane.normal,n),polyPlane.normal);
			var mouseOnPolygon:Number3D = Number3D.cross(Number3D.cross(rotPolyNormal,n),rotPolyNormal);
//			trace("mouse cross plane cross plane " + mouseOnPolygon.toString());
			mouseOnPolygon.normalize();
			//trace("mouse direction to " + mouseOnPolygon.toString());
			myCurrentRotations = new Vector.<Rotation>();
			for each (var ro:Rotation in myTwisty.rotations) {
				if (ro.isMyPoint(transformedMidPoint)) {
					myCurrentRotations.push(ro);
				}
			}
			//trace("I have " + myRotations.length.toString() + " rotations");
			//trace("I have " + myCurrentRotations.length.toString() + " current rotations");
			var minDist:Number = 100;
			currentRot = myRotations[0];
			rotationCount=0;
			for each (var r:Rotation in myCurrentRotations) {
				//trace("rotation axis " + r.normal.toString());
				//var rotOnPolygon:Number3D = Number3D.cross(polyPlane.normal,r.normal);
				var rotOnPolygon:Number3D = Number3D.cross(rotPolyNormal,r.normal);
				trace("checking rotation");
				if (rotOnPolygon.isModuloLessThan(0.2)) continue;
				trace("rotation OK");
				rotOnPolygon.normalize();
				//trace("rotation direction to " + rotOnPolygon.toString());
				rotOnPolygon.minusEq(mouseOnPolygon);
				var dist:Number = rotOnPolygon.moduloSquared;
				//trace("rotation has dist " + dist.toString());
				if (dist < minDist) {
					currentRot=r;
					minDist=dist;
				}
			}
			//trace("found rotation axis " + currentRot.normal.toString());
			currentPolys = new Vector.<Polygon3D>();
			for each (var pp:Polygon3D in myTwisty.polygons) {
				if (currentRot.isMyPoint(pp.transformedMidPoint)) {
					// trace("found polygon midpoint in rotation " + pp.midPoint.toString());
					// trace("with translated midpoint " + pp.transformedMidPoint.toString());
					currentPolys.push(pp);
				}
			}
			prepareRotation(currentRot);
			myTwisty.inProgress = true;
			tween.addEventListener(Event.ENTER_FRAME, doRotate);
		}

		private function prepareRotation(r:Rotation):void {
			var rotDelta:Number = 360/rotationMax/r.angle*toRADIANS;
			rotationMatrix = Matrix3D.rotationMatrix(r.normal.x, r.normal.y, r.normal.z, rotDelta, rotationMatrix);
		}
		
		public function resetRotation():void {
			transform = Matrix3D.IDENTITY;
			updateMidPoint();
		}
		
		public function prepareBackRotation():void {
			var cosRotAngle:Number = (transform.n11+transform.n22+transform.n33-1)/2;
			if (cosRotAngle>=1-BasisShape3D.epsilon) return; // not rotated
			var x:Number,y:Number,z:Number;
			var rotAngle:Number;
			if (cosRotAngle>= -1+BasisShape3D.epsilon) {
				rotAngle = Math.acos(cosRotAngle);
				var sin2:Number = 2*Math.sin(rotAngle);
				x = (transform.n23-transform.n32)/sin2;
				y = (transform.n31-transform.n13)/sin2;
				z = (transform.n12-transform.n21)/sin2;
			} else {
				rotAngle = Math.acos(-1);
				x = Math.sqrt(Math.abs(transform.n11+1)/2);
				y = Math.sqrt(Math.abs(transform.n22+1)/2);
				if (transform.n12<0) y=-y;
				z = Math.sqrt(Math.abs(transform.n33+1)/2);
				if (transform.n13<0) z=-z;
			}
			var rotDelta:Number = rotAngle/rotationMax;
			rotationMatrix = Matrix3D.rotationMatrix(x, y, z, rotDelta, rotationMatrix);
			rotationCount=0;
			currentPolys = new Vector.<Polygon3D>();
			currentPolys.push(this);
			tween.addEventListener(Event.ENTER_FRAME, doRotate);
		}
		
		private function updateMidPoint():void {
			transformedMidPoint = MyUtils.transformNumber(midPoint, transform);
		}
		
		public function doRotate(event:Event):void {
			const delay: Number = 3;
			if (rotationCount % delay == 0)
				for each (var p:Polygon3D in currentPolys) {
					p.transform = Matrix3D.multiply(rotationMatrix, p.transform)
				}
			rotationCount++;
			if (rotationCount == rotationMax*delay) {
				for each (p in currentPolys) {
					p.updateMidPoint();
				}
				myTwisty.inProgress = false;
				tween.removeEventListener(Event.ENTER_FRAME, doRotate);
			}
		}
		
		protected function buildPolygon():void {
			this.material.registerObject(this); // needed for the shaders.
			
			var vertices   :Array = this.geometry.vertices;
			var faces      :Array = this.geometry.faces;
			var planeVerts :Array = new Array();
			var i:int;
			
			// Vertices
			for( i = 0; i<corners.length; i++ ) {
				var vertex:Vertex3D = new Vertex3D(corners[i].x,corners[i].y,corners[i].z);
				vertices.push( vertex );
				planeVerts.push( vertex );
				// trace("pushed a vertex");
			}
			
			// Faces
			for( i=1; i<planeVerts.length-1; i++) {
				var uvA:NumberUV =  new NumberUV( 0, 0 );
				var uvC:NumberUV =  new NumberUV( 0, 1 );
				var uvB:NumberUV =  new NumberUV( 1, 1 );
				// trace("created a face for: " + i.toString());
				faces.push(new Triangle3D(this, [ planeVerts[0], planeVerts[i], planeVerts[i+1] ], this.material, [ uvA, uvB, uvC ] ) );
			}

			mergeVertices();
			
			for each(var t:Triangle3D in this.geometry.faces){
				t.renderCommand.create = createRenderTriangle;
			}
			
			this.geometry.ready = true;
			
			if(Papervision3D.useRIGHTHANDED)
				this.geometry.flipFaces();
		}
	
		public function destroy():void {
			this.material.unregisterObject(this);
		}
	}
}