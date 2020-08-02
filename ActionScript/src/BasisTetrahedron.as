package {
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;

	public class BasisTetrahedron extends BasisShape3D {
		private var tetraColors:Vector.<MaterialObject3D> = new Vector.<MaterialObject3D>();

		public function BasisTetrahedron() {
			var c1:Number3D,c2:Number3D,c3:Number3D,c4:Number3D;
			corners.push(c1=new Number3D(scale,scale,scale));
			corners.push(c2=new Number3D(-scale,-scale,scale));
			corners.push(c3=new Number3D(-scale,scale,-scale));
			corners.push(c4=new Number3D(scale,-scale,-scale));
			
			var vec1:Vector.<Number3D> = new Vector.<Number3D>();
			vec1.push(c1,c2,c3);
			sides.push(new Polygon(vec1));
			var vec2:Vector.<Number3D> = new Vector.<Number3D>();
			vec2.push(c1,c4,c2);
			sides.push(new Polygon(vec2));
			var vec3:Vector.<Number3D> = new Vector.<Number3D>();
			vec3.push(c1,c3,c4);
			sides.push(new Polygon(vec3));
			var vec4:Vector.<Number3D> = new Vector.<Number3D>();
			vec4.push(c2,c4,c3);
			sides.push(new Polygon(vec4));
			var vec5:Vector.<Number3D> = new Vector.<Number3D>();
			tetraColors.push(orange, blue, gold, green);
			myColoring=new Coloring3D(tetraColors,true);
		}
	}
}