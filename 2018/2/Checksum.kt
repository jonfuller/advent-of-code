import java.io.File;

fun main(args: Array<String>) {
    var input = File("input")
        .readLines()
        ;

    for (i in 0..input.first().length-1) {
        var y = hasDupAfterRemovingChar(input, i)
        if (y.hasDuplicate && y.duplicates != null) {
            println(y.duplicates)
            break
        }
    }
}

data class DupResult(val hasDuplicate: Boolean, val duplicates: String?)

fun hasDupAfterRemovingChar(input: List<String>, position: Int): DupResult {
    var duplicates = input
        .map { l -> l.removeRange(position, position + 1).toString() }
        .groupBy { it }
        .filter { g -> g.value.count() > 1 }

    if (duplicates.any())
        return DupResult(true, duplicates.keys.first())
    else
        return DupResult(false, null);
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
