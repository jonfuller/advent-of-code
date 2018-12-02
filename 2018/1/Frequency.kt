import java.io.File;

fun main(args: Array<String>) {
    var input = File("input")
        .readLines()
        .map { l -> l.toInt() }
        ;
    
    var sum = input.reduce { total, next -> total + next }
    println(sum)
}
