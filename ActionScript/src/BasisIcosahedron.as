package {
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;

	public class BasisIcosahedron extends BasisShape3D {
		private var icosaColors:Vector.<MaterialObject3D> = new Vector.<MaterialObject3D>();

		public function BasisIcosahedron() {
			var c1:Number3D,c2:Number3D,c3:Number3D,c4:Number3D;
			var c5:Number3D,c6:Number3D,c7:Number3D,c8:Number3D;
			var c9:Number3D,c10:Number3D,c11:Number3D,c12:Number3D;
			const halfSide:Number=scale*0.8;
			const dist:Number = halfSide*(1+Math.sqrt(5))/2;
			corners.push(c1=new Number3D(halfSide,0,dist));
			corners.push(c2=new Number3D(-halfSide,0,dist));
			corners.push(c3=new Number3D(halfSide,0,-dist));
			corners.push(c4=new Number3D(-halfSide,0,-dist));
			corners.push(c5=new Number3D(0,dist,halfSide));
			corners.push(c6=new Number3D(0,dist,-halfSide));
			corners.push(c7=new Number3D(0,-dist,halfSide));
			corners.push(c8=new Number3D(0,-dist,-halfSide));
			corners.push(c9=new Number3D(dist,halfSide,0));
			corners.push(c10=new Number3D(dist,-halfSide,0));
			corners.push(c11=new Number3D(-dist,halfSide,0));
			corners.push(c12=new Number3D(-dist,-halfSide,0));
			
			var vec1:Vector.<Number3D> = new Vector.<Number3D>();
			vec1.push(c1,c2,c5);
			sides.push(new Polygon(vec1));
			var vec2:Vector.<Number3D> = new Vector.<Number3D>();
			vec2.push(c2,c1,c7);
			sides.push(new Polygon(vec2));
			var vec3:Vector.<Number3D> = new Vector.<Number3D>();
			vec3.push(c3,c4,c8);
			sides.push(new Polygon(vec3));
			var vec4:Vector.<Number3D> = new Vector.<Number3D>();
			vec4.push(c4,c3,c6);
			sides.push(new Polygon(vec4));
			var vec5:Vector.<Number3D> = new Vector.<Number3D>();
			vec5.push(c5,c6,c9);
			sides.push(new Polygon(vec5));
			var vec6:Vector.<Number3D> = new Vector.<Number3D>();
			vec6.push(c6,c5,c11);
			sides.push(new Polygon(vec6));
			var vec7:Vector.<Number3D> = new Vector.<Number3D>();
			vec7.push(c7,c8,c12);
			sides.push(new Polygon(vec7));
			var vec8:Vector.<Number3D> = new Vector.<Number3D>();
			vec8.push(c8,c7,c10);
			sides.push(new Polygon(vec8));
			var vec9:Vector.<Number3D> = new Vector.<Number3D>();
			vec9.push(c9,c10,c1);
			sides.push(new Polygon(vec9));
			var vec10:Vector.<Number3D> = new Vector.<Number3D>();
			vec10.push(c10,c9,c3);
			sides.push(new Polygon(vec10));
			var vec11:Vector.<Number3D> = new Vector.<Number3D>();
			vec11.push(c11,c12,c4);
			sides.push(new Polygon(vec11));
			var vec12:Vector.<Number3D> = new Vector.<Number3D>();
			vec12.push(c12,c11,c2);
			sides.push(new Polygon(vec12));
			var vec13:Vector.<Number3D> = new Vector.<Number3D>();
			vec13.push(c1,c5,c9);
			sides.push(new Polygon(vec13));
			var vec14:Vector.<Number3D> = new Vector.<Number3D>();
			vec14.push(c9,c6,c3);
			sides.push(new Polygon(vec14));
			var vec15:Vector.<Number3D> = new Vector.<Number3D>();
			vec15.push(c4,c6,c11);
			sides.push(new Polygon(vec15));
			var vec16:Vector.<Number3D> = new Vector.<Number3D>();
			vec16.push(c11,c5,c2);
			sides.push(new Polygon(vec16));
			var vec17:Vector.<Number3D> = new Vector.<Number3D>();
			vec17.push(c1,c10,c7);
			sides.push(new Polygon(vec17));
			var vec18:Vector.<Number3D> = new Vector.<Number3D>();
			vec18.push(c10,c3,c8);
			sides.push(new Polygon(vec18));
			var vec19:Vector.<Number3D> = new Vector.<Number3D>();
			vec19.push(c4,c12,c8);
			sides.push(new Polygon(vec19));
			var vec20:Vector.<Number3D> = new Vector.<Number3D>();
			vec20.push(c12,c2,c7);
			sides.push(new Polygon(vec20));
			icosaColors.push(yellow, blue, blue, yellow, red, green);
			icosaColors.push(green, red, white, orange, orange, white);
			myColoring=new Coloring3D(icosaColors,false);
		}
	}
}