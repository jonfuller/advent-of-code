import java.io.File;

fun main(args: Array<String>) {
    var input = File("input")
        .readLines()
        .map { l -> l.toInt() }
        ;

    var freqMap = hashSetOf<Int>(0)

    var result = Result(0, null);
    while (result.repeating == null) {
        result = findRepeat(result.ending, input, freqMap);
    }

    println(result.repeating?.toString())
    println(result.ending)
}

data class Result(val ending: Int, val repeating: Int?)

fun findRepeat(starting: Int, input: List<Int>, freqMap: HashSet<Int>): Result {
    var repeat :Int? = null
    var sum = input.fold(starting) { total, next ->
        var freq = total + next
        
        if (freqMap.contains(freq) && repeat == null)
            repeat = freq
        else
            freqMap.add(freq)

        freq
    }
    return Result(sum, repeat)
}

fun debugLoop(total: Int, next: Int, freq: Int) {
    debug(total.toString())
    debug(next.toString())
    debug(freq.toString())
    debug("----")
}
fun debug(arg: String) {
    println(arg);
}