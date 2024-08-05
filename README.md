# Mudlet-Scroll-Benchmark
A simple benchmark for UI performance in Mudlet. Requires demmonic's [Stressinator](https://github.com/demonnic/Stressinator/releases).

Usage:

`^SCROLL(?: (?<stepSize>\d+))(?: (?<length>\d+))??$` - Start the benchmark with the specified step size and line length.
`^STOPSCROLL$` - What it says on the tin.

I'll clean the source up and properly package it with demmonic's [Muddler](https://github.com/demonnic/muddler) at some point in the future. Source code is under `./unMuddledSource` in the meanwhile.