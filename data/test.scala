trait C {
  def a = 1
  val y = 2
}                                                   // defined trait C

class A extends C {

}                                                   // defined class A

object B extends C {

}                                                   // defined module B
val a = "asd"                                       // a: java.lang.String = asd
new A()                                             // res11: A = A@73a6068c
B.a                                                 // res12: Int = 1


def f(n:Int) = n * 2                                // f: (n: Int)Int
f(1000)                                             // res13: Int = 2000

2 / 0                                               // java.lang.ArithmeticException: / by zero
                                                    // 	at .<init>(<console>:8)
                                                    // 	at .<clinit>(<console>)
