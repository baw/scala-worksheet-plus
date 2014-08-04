trait C {
  def a = 1
  val y = 2
}                                                   // defined trait C

class A extends C {

}                                                   // defined class A

object B extends C {

}                                                   // defined module B
val a = "asd"                                       // a: java.lang.String = asd
new A()                                             // res2: A = A@5b54a573
B.a                                                 // res3: Int = 1
