
package fluidity;

enum Graphic {

  Image(filename:String);
  Animation(filename:String,numFrames:Int,frameLength:Int,loop:Bool);
  SpriteSheet(filename:String,width:Int,height:Int,frames:Array<Int>,frameLength:Int,loop:Bool);
}