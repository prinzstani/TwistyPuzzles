package {
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;

	public class BasisCube extends BasisShape3D {
		private var cubeColors:Vector.<MaterialObject3D> = new Vector.<MaterialObject3D>();

		public function BasisCube() {
			var c1:Number3D,c2:Number3D,c3:Number3D,c4:Number3D;
			var c5:Number3D,c6:Number3D,c7:Number3D,c8:Number3D;
			corners.push(c1=new Number3D(scale,scale,scale));
			corners.push(c2=new Number3D(-scale,scale,scale));
			corners.push(c3=new Number3D(scale,-scale,scale));
			corners.push(c4=new Number3D(scale,scale,-scale));
			corners.push(c5=new Number3D(-scale,-scale,scale));
			corners.push(c6=new Number3D(-scale,scale,-scale));
			corners.push(c7=new Number3D(scale,-scale,-scale));
			corners.push(c8=new Number3D(-scale,-scale,-scale));
			
			var vec1:Vector.<Number3D> = new Vector.<Number3D>();
			vec1.push(c1,c4,c7,c3);
			sides.push(new Polygon(vec1));
			var vec2:Vector.<Number3D> = new Vector.<Number3D>();
			vec2.push(c1,c2,c6,c4);
			sides.push(new Polygon(vec2));
			var vec3:Vector.<Number3D> = new Vector.<Number3D>();
			vec3.push(c1,c3,c5,c2);
			sides.push(new Polygon(vec3));
			var vec4:Vector.<Number3D> = new Vector.<Number3D>();
			vec4.push(c2,c5,c8,c6);
			sides.push(new Polygon(vec4));
			var vec5:Vector.<Number3D> = new Vector.<Number3D>();
			vec5.push(c3,c7,c8,c5);
			sides.push(new Polygon(vec5));
			var vec6:Vector.<Number3D> = new Vector.<Number3D>();
			vec6.push(c4,c6,c8,c7);
			sides.push(new Polygon(vec6));
			cubeColors.push(white, orange, blue, yellow, red, green);
			myColoring=new Coloring3D(cubeColors,true);
		}
	}
}