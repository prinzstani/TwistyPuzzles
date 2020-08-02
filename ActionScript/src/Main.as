package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.render.QuadrantRenderEngine;
	import org.papervision3d.view.BasicView;
	
	[SWF(backgroundColor=0xFFFFFF, width=465, height=465, frameRate=30)]
	
	public class Main extends Sprite {
		public var view:BasicView;
		public var mdp:Point = new Point(); // mouse down point
		public var dragPoint:Point = new Point();
		public var background:Sprite;

		private var thePuzzles:Vector.<TwistyPuzzle>=new Vector.<TwistyPuzzle>();
		private var messageArea:TextField = new TextField();

		public function doQuickSolve(event:MouseEvent):void
		{
			for each (var poly:Polygon3D in TwistyPuzzle.activeTwisty.polygons) {
				poly.resetRotation();
			}
			messageArea.text="";
		}

		public function doSuperSolve(event:MouseEvent):void
		{
			for each (var poly:Polygon3D in TwistyPuzzle.activeTwisty.polygons) {
				poly.prepareBackRotation();
			}
		}
		
		public function doScramble(event:MouseEvent):void
		{
			messageArea.text="Scramble not implemented yet.";
		}
		
		public function Main() {
			var menuTetra:TwistyPuzzle;
			var menuCube:TwistyPuzzle;
			var menuCube2:TwistyPuzzle;
			var menuCube3:TwistyPuzzle;
			var menuCube4:TwistyPuzzle;
			var menuOcta:TwistyPuzzle;
			var menuOcta2:TwistyPuzzle;
			var menuDodec:TwistyPuzzle;
			var menuIco:TwistyPuzzle;

			background = new Sprite();
			background.graphics.beginFill(0x0,1);
			background.graphics.drawRect(0,0,465,465);
			background.graphics.endFill();
			addChild(background);

			messageArea.border=true;
			messageArea.borderColor = YELLOW;
			messageArea.textColor = YELLOW;
			messageArea.x = 5;
			messageArea.y = 440;
			messageArea.width = 455;
			messageArea.height = 20;
			messageArea.selectable = false;
			messageArea.text = "messageArea";
			addChild(messageArea);

			init3DEngine();			

			createTwisty(new BasisCube(),3,true,2);
			createTwisty(new BasisCube(),0,false,0);
			createTwisty(new BasisCube(),2,true,1);
			createTwisty(new BasisCube(),4,true,3);
			createTwisty(new BasisCube(),5,true,4);
			createTwisty(new BasisTetrahedron(),3,true,5);
			createTwisty(new BasisOctahedron(true),3,true,6);
			createTwisty(new BasisOctahedron(false),1,false,7);
			createTwisty(new BasisDodecahedron(),2,true,8);
			createTwisty(new BasisIcosahedron(),1,false,9);
			
			createButton("QuickSolve",doQuickSolve,0);
			createButton("SuperSolve",doSuperSolve,1);
			createButton("Scramble",doScramble,2);
}

		private function position(num:Number):Number3D {
			const count:Number = 5;
			return new Number3D(-200+100*(num % count),200-400*((int)(num / count)),300);
		}

		private function createTwisty(shape:BasisShape3D, cutCount:Number, cutSide:Boolean, myPos:Number): void {
			var theItem:TwistyPuzzle = 
				new TwistyPuzzle(this, shape, new Cutting3D(cutCount,cutSide), position(myPos));
			view.scene.addChild(theItem);
			thePuzzles.push(theItem);
		}

		private function createButton(text:String, listener:Function, position:Number):void {
			var theButton:TextField = new TextField();
			theButton.text = text;
			theButton.border=true;
			theButton.borderColor = YELLOW;
			theButton.textColor = YELLOW;
			theButton.x = 380;
			theButton.y = 150+position*30;
			theButton.width = 80;
			theButton.height = 20;
			theButton.selectable = false;
			theButton.addEventListener(MouseEvent.MOUSE_DOWN,listener);
			this.addChild(theButton);
		}
		
		private function init3DEngine():void {
			view = new BasicView(0, 0, true, true, "Target");						
			view.camera.z = -100;
			view.buttonMode = true;
			view.renderer = new QuadrantRenderEngine(QuadrantRenderEngine.CORRECT_Z_FILTER);
			
			addChild(view);
			addEventListener(Event.ENTER_FRAME, onEventRender3D);
			addEventListener(MouseEvent.MOUSE_DOWN, startRotatePuzzle);
		}
		
		private function startRotatePuzzle(event:MouseEvent):void {
			if (event.target != background) return;
			
			addEventListener(MouseEvent.MOUSE_UP, endDrag);
			addEventListener(Event.MOUSE_LEAVE, endDrag);
			addEventListener(MouseEvent.MOUSE_MOVE, rotatePuzzle);
			
			mdp.x = mouseX;
			mdp.y = mouseY;
		}
		
		public function endDrag(event:Event = null):void {
			removeEventListener(MouseEvent.MOUSE_UP, endDrag);
			removeEventListener(Event.MOUSE_LEAVE, endDrag);
			removeEventListener(MouseEvent.MOUSE_MOVE, rotatePuzzle);
		}
		
		public function rotatePuzzle(event:Event=null):void {
			var m:Matrix3D = Matrix3D.rotationY((mouseX - mdp.x)/150);
			m = Matrix3D.multiply(m, Matrix3D.rotationX(-(mouseY - mdp.y)/150));
			TwistyPuzzle.activeTwisty.transform = Matrix3D.multiply(m, TwistyPuzzle.activeTwisty.transform);
			
			mdp.x = mouseX;
			mdp.y = mouseY;
		}
		
		private function onEventRender3D(e:Event):void {
			for each(var p:TwistyPuzzle in thePuzzles) {
				if(p!=TwistyPuzzle.activeTwisty) {
					p.rotationX+=1;
					p.rotationY+=2;
				}
			}
			view.singleRender();
		}

		private static const RED:uint = 0xFF0000;
		private static const GREEN:uint = 0x00FF00;
		private static const BLUE:uint = 0x0000FF;
		private static const BLACK:uint = 0x000000;
		private static const WHITE:uint = 0xFFFFFF;
		private static const CYAN:uint = 0x00FFFF;
		private static const MAGENTA:uint = 0xFF00FF;
		private static const YELLOW:uint = 0xFFFF00;
		private static const LIGHT_GREY:uint = 0xCCCCCC;
		private static const MID_GREY:uint = 0x999999;
		private static const DARK_GREY:uint = 0x666666;
	}
}