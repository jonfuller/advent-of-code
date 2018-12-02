import java.io.File;

fun main(args: Array<String>) {
    var input = File("input")
        .readLines()
        ;
    
    var twos = input.filter { l -> hasTwoRepeats(l) };
    var threes = input.filter { l -> hasThreeRepeats(l) };

    println(twos.count())
    println(threes.count())
    println(twos.count() * threes.count())
}

fun hasTwoRepeats(line: String): Boolean {
    return hasRepeatsOf(line, 2)
}
fun hasThreeRepeats(line: String): Boolean {
    return hasRepeatsOf(line, 3)
}
fun hasRepeatsOf(line: String, length: Int): Boolean {
  return line
    .toCharArray()
    .sorted()
    .groupBy{ it }
    .map{ x -> x.value.count() }
    .contains(length)
}
