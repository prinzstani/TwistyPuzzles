package {
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.NumberUV;
	import org.papervision3d.core.math.Plane3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.ColorMaterial;
	
	public class MyUtils {
		public static function createColor(color:Number):MaterialObject3D {
			var local:ColorMaterial = new ColorMaterial(color);
			local.interactive = true;
			return local;
		}
		
		public static function transformNumber(n:Number3D, m:Matrix3D):Number3D {
			var v:Number3D = new Number3D(0,0,0);
			v.x = m.n11 * n.x + m.n12 * n.y + m.n13 * n.z;
			v.y = m.n21 * n.x + m.n22 * n.y + m.n23 * n.z;
			v.z = m.n31 * n.x + m.n32 * n.y + m.n33 * n.z;
			return v;
		}
		
		public static function isIDENTITY(m:Matrix3D):Boolean{
			var h:Number = 0;
			h = h + Math.abs(1-m.n11)+Math.abs(m.n12)+Math.abs(m.n13);
			h = h + Math.abs(m.n21)+Math.abs(1-m.n22)+Math.abs(m.n23);
			h = h + Math.abs(m.n31)+Math.abs(m.n32)+Math.abs(1-m.n33);
			return h<BasisShape3D.epsilon;
		}
		
		public static function mult(n:Number3D, i:Number):Number3D {
			return new Number3D(n.x*i, n.y*i, n.z*i);
		}
		
		public static function scalePoints(p1:Number3D, p2:Number3D, weight1:int, weight2:int):Number3D {
			var scale1:int=weight2;
			var scale2:int=weight1;
			var total:int=scale1+scale2;
			return new Number3D(
				(p1.x*scale1+p2.x*scale2)/total,
				(p1.y*scale1+p2.y*scale2)/total,
				(p1.z*scale1+p2.z*scale2)/total
			);
		}
		
		public static function getIntersectionLineNumbers( plane: Plane3D, v0: Number3D, v1: Number3D ): Number3D
		{ // to fix the function that Plane3D provides
			var normal:Number3D = plane.normal;
			var d:Number = plane.d;
			var d0: Number = normal.x * v0.x + normal.y * v0.y + normal.z * v0.z + d;
			var d1: Number = normal.x * v1.x + normal.y * v1.y + normal.z * v1.z + d;
			var m: Number = d1 / ( d1 - d0 );
			
			return new Number3D(
				v1.x + ( v0.x - v1.x ) * m,
				v1.y + ( v0.y - v1.y ) * m,
				v1.z + ( v0.z - v1.z ) * m
			);
		}

		public static function rotationY( rad:Number ):Matrix3D
		{ // to fix the function that Matrix3D provides
			var m :Matrix3D = Matrix3D.IDENTITY;
			var c :Number   = Math.cos( rad );
			var s :Number   = Math.sin( rad );
			
			m.n11 =  c;
			m.n13 =  s;
			m.n31 = -s;
			m.n33 =  c;
			
			return m;
		}
	}
}