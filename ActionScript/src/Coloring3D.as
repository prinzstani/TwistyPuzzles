package {
	import org.papervision3d.core.proto.MaterialObject3D;

	public class Coloring3D {
		public var materials:Vector.<MaterialObject3D>;
		public var sideColoring:Boolean; // as opposed to corner coloring
		
		public function Coloring3D(mat:Vector.<MaterialObject3D>, side:Boolean) {
			materials=mat;
			sideColoring=side;
		}
	}
}
