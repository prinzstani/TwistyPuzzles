package {
	import org.papervision3d.core.math.Number3D;

	public class LineIn3D {
		public var first:Number3D;
		public var second:Number3D;
		
		public function LineIn3D(fst:Number3D,snd:Number3D) {
			first=fst;
			second=snd;
		}
		
		public function toString():String {
			return "line from " + first.toString() + " to " + second.toString();
		}
	}
}