# Mudlet-Scroll-Benchmark
A simple benchmark for UI performance in Mudlet. Requires demmonic's [Stressinator](https://github.com/demonnic/Stressinator/releases).  
  
## Usage:
1. `^SCROLL(?: (?<stepSize>\d+))(?: (?<length>\d+))??$` - Start the benchmark with the specified step size and line length.  
1. `^STOPSCROLL$` - What it says on the tin.  

## Disclaimer:
Please make sure you understand what Stressinator does before you run this.

## Notes
I'll clean the source up and properly package it with demmonic's [Muddler](https://github.com/demonnic/muddler) at some point in the future. Source code is under `./unMuddledSource` in the meanwhile.