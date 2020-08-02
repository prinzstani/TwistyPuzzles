package {
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;

	public class BasisOctahedron extends BasisShape3D {
		private var octaColors:Vector.<MaterialObject3D> = new Vector.<MaterialObject3D>();

		public function BasisOctahedron(sideColor:Boolean) {
			var c1:Number3D,c2:Number3D,c3:Number3D;
			var c4:Number3D,c5:Number3D,c6:Number3D;
			const midDist:Number=scale*1.73; /*sqrt(3*/
			corners.push(c1=new Number3D(midDist,0,0));
			corners.push(c2=new Number3D(-midDist,0,0));
			corners.push(c3=new Number3D(0,midDist,0));
			corners.push(c4=new Number3D(0,-midDist,0));
			corners.push(c5=new Number3D(0,0,midDist));
			corners.push(c6=new Number3D(0,0,-midDist));
			
			var vec1:Vector.<Number3D> = new Vector.<Number3D>();
			vec1.push(c1,c3,c6);
			sides.push(new Polygon(vec1));
			var vec2:Vector.<Number3D> = new Vector.<Number3D>();
			vec2.push(c1,c5,c3);
			sides.push(new Polygon(vec2));
			var vec3:Vector.<Number3D> = new Vector.<Number3D>();
			vec3.push(c1,c4,c5);
			sides.push(new Polygon(vec3));
			var vec4:Vector.<Number3D> = new Vector.<Number3D>();
			vec4.push(c1,c6,c4);
			sides.push(new Polygon(vec4));
			var vec5:Vector.<Number3D> = new Vector.<Number3D>();
			vec5.push(c2,c5,c4);
			sides.push(new Polygon(vec5));
			var vec6:Vector.<Number3D> = new Vector.<Number3D>();
			vec6.push(c2,c4,c6);
			sides.push(new Polygon(vec6));
			var vec7:Vector.<Number3D> = new Vector.<Number3D>();
			vec7.push(c2,c6,c3);
			sides.push(new Polygon(vec7));
			var vec8:Vector.<Number3D> = new Vector.<Number3D>();
			vec8.push(c2,c3,c5);
			sides.push(new Polygon(vec8));
			
			if(sideColor) {
				octaColors.push(orange, blue, yellow, green, white, red, gold, brown);
			} else {
				octaColors.push(white, orange, blue, yellow, red, green);
			}
			myColoring=new Coloring3D(octaColors,sideColor);
		}
	}
}