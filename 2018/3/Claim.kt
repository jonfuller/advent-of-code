import java.io.File;

    fun main(args: Array<String>) {
        var claims = File("input")
            .readLines()
            .map {parseClaim(it)}

        var width = claims.maxBy { it.x }!!.x + claims.maxBy { it.width }!!.width - 1
        var height = claims.maxBy { it.y }!!.y + claims.maxBy { it.height }!!.height - 1

        var fabric = generateSequence { generateSequence { 0 }.take(width).toList().asIterable() }.take(height).toList().asIterable()

        fabric = claims.fold(fabric) { acc, claim -> claimFabric(acc, claim)}

        var pureClaims = claims.filter { claim -> getClaim(fabric, claim).flatten().all{ it == 1 } }

        println(fabric.flatten().count { it > 1 })
        pureClaims.map { it.id }.forEach(::println)
    }

data class Claim(val id: String, val x: Int, val y: Int, val height: Int, val width: Int)

fun getClaim(fabric: Iterable<Iterable<Int>>, claim: Claim): Iterable<Iterable<Int>> {
    return fabric
        .drop(claim.y)
        .take(claim.height)
        .map {it.drop(claim.x).take(claim.width)}
}

fun claimFabric(fabric: Iterable<Iterable<Int>>, claim: Claim): Iterable<Iterable<Int>> {
    return sequence {
        yieldAll(fabric.take(claim.y))
        yieldAll(fabric.drop(claim.y).take(claim.height).map { claimRow(it, claim.x, claim.width) })
        yieldAll(fabric.drop(claim.y + claim.height))
    }.toList()
}

fun claimRow(line: Iterable<Int>, start: Int, width: Int): Iterable<Int> {
    return sequence {
        yieldAll(line.take(start))
        yieldAll(line.drop(start).take(width).map { it+1 })
        yieldAll(line.drop(start + width))
    }.toList()
}

fun parseClaim(line: String): Claim {
    var spaced = line.split(" ")
    var location = spaced[2].dropLast(1).split(",")
    var size = spaced[3].split("x")

    return Claim(spaced[0].drop(1), location[0].toInt(), location[1].toInt(), size[1].toInt(), size[0].toInt())
}

fun debug(fabric: Iterable<Iterable<Int>>) {
    fabric
        .forEach {
            it.forEach { i -> print(i) }
            println()
        }
}
