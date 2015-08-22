
package fluidity2;

enum Collider {
  None;
  Circle(x:Float, y:Float, r:Float);
  Rectangle(x:Float, y:Float, w:Float, h:Float);
}