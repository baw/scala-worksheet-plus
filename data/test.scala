trait C {
  def a = 1
  val y = 2
}                                                   // defined trait C

class A extends C {

}                                                   // defined class A

object B extends C {

}                                                   // defined object B
val a = "asd"                                       // a: String = asd
new A()                                             // res2: A = A@4f91912f
B.a                                                 // res3: Int = 1
val a = 1                                           // a: Int = 1
