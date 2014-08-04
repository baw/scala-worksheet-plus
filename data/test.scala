trait C {
  def a = 1
  val y = 2
}                                                   // defined trait C

class A extends C {

}                                                   // defined class A

object B extends C {

}
val a = "asd"                                       // a: java.lang.String = asd
new A()                                             // res1: A = A@1cb6847f
B.a
