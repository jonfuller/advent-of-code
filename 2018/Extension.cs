using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Aoc._2018
{
    public static class Extension
    {
        public static T MaxBy<T, U>(this IEnumerable<T> target, Func<T, U> selector) where U : IComparable<U>
        {
            return target.OrderByDescending(selector).FirstOrDefault();
        }
        public static void WriteLines(this TextWriter target, IEnumerable<string> lines)
        {
            foreach (var line in lines)
            {
                target.WriteLine(line);
            }
        }

        public static void WriteLines<T>(this TextWriter target, IEnumerable<T> items, Func<T, string> map)
        {
            target.WriteLines(items.Select(map));
        }
    }
}