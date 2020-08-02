package {
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;

	public class BasisDodecahedron extends BasisShape3D {
		private var dodecColors:Vector.<MaterialObject3D> = new Vector.<MaterialObject3D>();

		public function BasisDodecahedron() {
			var c1:Number3D,c2:Number3D,c3:Number3D,c4:Number3D,c5:Number3D;
			var c6:Number3D,c7:Number3D,c8:Number3D,c9:Number3D,c10:Number3D;
			var c11:Number3D,c12:Number3D,c13:Number3D,c14:Number3D,c15:Number3D;
			var c16:Number3D,c17:Number3D,c18:Number3D,c19:Number3D,c20:Number3D;
			const h:Number = 2*scale/(1+Math.sqrt(5));
			corners.push(c1=new Number3D(scale,scale,scale));
			corners.push(c2=new Number3D(-scale,scale,scale));
			corners.push(c3=new Number3D(scale,-scale,scale));
			corners.push(c4=new Number3D(scale,scale,-scale));
			corners.push(c5=new Number3D(-scale,-scale,scale));
			corners.push(c6=new Number3D(-scale,scale,-scale));
			corners.push(c7=new Number3D(scale,-scale,-scale));
			corners.push(c8=new Number3D(-scale,-scale,-scale));
			corners.push(c9=new Number3D(h,0,scale+h));
			corners.push(c10=new Number3D(-h,0,scale+h));
			corners.push(c11=new Number3D(h,0,-scale-h));
			corners.push(c12=new Number3D(-h,0,-scale-h));
			corners.push(c13=new Number3D(0,scale+h,h));
			corners.push(c14=new Number3D(0,scale+h,-h));
			corners.push(c15=new Number3D(0,-scale-h,h));
			corners.push(c16=new Number3D(0,-scale-h,-h));
			corners.push(c17=new Number3D(scale+h,h,0));
			corners.push(c18=new Number3D(scale+h,-h,0));
			corners.push(c19=new Number3D(-scale-h,h,0));
			corners.push(c20=new Number3D(-scale-h,-h,0));
			
			var vec1:Vector.<Number3D> = new Vector.<Number3D>();
			vec1.push(c1,c13,c14,c4,c17);
			sides.push(new Polygon(vec1));
			var vec2:Vector.<Number3D> = new Vector.<Number3D>();
			vec2.push(c6,c14,c13,c2,c19);
			sides.push(new Polygon(vec2));
			var vec3:Vector.<Number3D> = new Vector.<Number3D>();
			vec3.push(c6,c12,c11,c4,c14);
			sides.push(new Polygon(vec3));
			var vec4:Vector.<Number3D> = new Vector.<Number3D>();
			vec4.push(c1,c9,c10,c2,c13);
			sides.push(new Polygon(vec4));
			var vec5:Vector.<Number3D> = new Vector.<Number3D>();
			vec5.push(c6,c19,c20,c8,c12);
			sides.push(new Polygon(vec5));
			var vec6:Vector.<Number3D> = new Vector.<Number3D>();
			vec6.push(c4,c11,c7,c18,c17);
			sides.push(new Polygon(vec6));
			var vec7:Vector.<Number3D> = new Vector.<Number3D>();
			vec7.push(c1,c17,c18,c3,c9);
			sides.push(new Polygon(vec7));
			var vec8:Vector.<Number3D> = new Vector.<Number3D>();
			vec8.push(c2,c10,c5,c20,c19);
			sides.push(new Polygon(vec8));
			var vec9:Vector.<Number3D> = new Vector.<Number3D>();
			vec9.push(c8,c16,c7,c11,c12);
			sides.push(new Polygon(vec9));
			var vec10:Vector.<Number3D> = new Vector.<Number3D>();
			vec10.push(c3,c15,c5,c10,c9);
			sides.push(new Polygon(vec10));
			var vec11:Vector.<Number3D> = new Vector.<Number3D>();
			vec11.push(c3,c18,c7,c16,c15);
			sides.push(new Polygon(vec11));
			var vec12:Vector.<Number3D> = new Vector.<Number3D>();
			vec12.push(c8,c20,c5,c15,c16);
			sides.push(new Polygon(vec12));
			dodecColors.push(white, orange, blue, yellow, green, red);
			dodecColors.push(green, red, yellow, blue, orange, white);
			myColoring=new Coloring3D(dodecColors,true);
		}
	}
}