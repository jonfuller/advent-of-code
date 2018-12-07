using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Aoc._2018
{
    public class Guard
    {
        public string Description { get; set; }
        public IEnumerable<(DateTime start, DateTime end)> Times { get; set; }

        public double MinutesAsleep
        {
            get { return Spans.Sum(s => s.TotalMinutes); }
        }

        private IEnumerable<TimeSpan> Spans
        {
            get { return Times.Select(t => t.end - t.start); }
        }

        public (int minute, int times) MostFreqMinute
        {
            get
            {
                return AsleepMinutes
                    .Select((val, i) => (minute: i, times: val))
                    .MaxBy(x => x.times);
            }
        }

        private int[] AsleepMinutes
        {
            get
            {
                var minutes = new int[60];

                foreach (var time in Times)
                {
                    for (var i = time.start.Minute; i < time.end.Minute; i++)
                        minutes[i] += 1;
                }

                return minutes;
            }
        }
    }

    public class LogEntry
    {
        public DateTime timestamp;
        public string description;
    }

    public static class Helper
    {
        public static IEnumerable<IEnumerable<LogEntry>> GroupEntries(this IEnumerable<LogEntry> target)
        {
            return Grouped().Where(g => g.Any());

            IEnumerable<IEnumerable<LogEntry>> Grouped()
            {
                var group = Enumerable.Empty<LogEntry>();
                foreach (var item in target)
                {
                    if (item.description.StartsWith("Guard #"))
                    {
                        yield return group;
                        group = Enumerable.Empty<LogEntry>();
                    }
                    group = group.Concat(new[] { item });
                }
            }
        }
    }
    public class Four
    {
        public static void Go()
        {
            var guards = File.ReadLines("2018/4/input")
                .Select(Parse)
                .OrderBy(x => x.timestamp)
                .GroupEntries()
                .Select(PairStartAndEnds)
                .GroupBy(pe => pe.Description, pg => pg.Times)
                .Select(g => new Guard() { Description = g.Key, Times = g.SelectMany(_ => _)})
                .ToList();

            var mostAsleep = guards
                .OrderByDescending(p => p.MinutesAsleep)
                .First();

            var mostOnSameMinute = guards
                .OrderByDescending(p => p.MostFreqMinute.times)
                .First();

            Console.Out.WriteLine($"{mostAsleep.Description} - {mostAsleep.MinutesAsleep} - {mostAsleep.MostFreqMinute.minute}");
            Console.Out.WriteLine($"{mostOnSameMinute.Description} - {mostOnSameMinute.MostFreqMinute.minute}");
        }

        private static Guard PairStartAndEnds(IEnumerable<LogEntry> group)
        {
            var listed = group.ToList();
            return new Guard
            {
                Description = listed.First().description,
                Times = GetSpans(listed.Skip(1).Select(x => x.timestamp).ToList()).ToList()
            };

            IEnumerable<(DateTime start, DateTime end)> GetSpans(IList<DateTime> stamps)
            {
                for (var i = 0; i < stamps.Count; i += 2)
                {
                    yield return (start: stamps[i], end: stamps[i + 1]);
                }
            }
        }

        static LogEntry Parse(string line)
        {
            var spaced = line.Split(" ");
            var date = spaced[0].TrimStart('[').Split('-');
            var time = spaced[1].TrimEnd(']').Split(':');
            return new LogEntry {
                timestamp = new DateTime(
                    int.Parse(date[0]),
                    int.Parse(date[1]),
                    int.Parse(date[2]),
                    int.Parse(time[0]),
                    int.Parse(time[1]),
                    0),
                description = string.Join(' ', spaced.Skip(2)).Trim()
            };
        }
    }
}