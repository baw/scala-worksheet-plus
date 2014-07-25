val a:Int = 3                                       // a: Int = 3
val b = "aa"                                        // b: java.lang.String = aa

def aa = "a"                                        // aa: java.lang.String

class A(x:Int, y:Int){
  def f = x * y + 2
}                                                   // defined class A

(new A(a, 2)).f                                     // res5: Int = 6
