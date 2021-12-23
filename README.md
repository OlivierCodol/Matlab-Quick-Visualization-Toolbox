# [Matlab] Mini Visualization Toolbox

This is a set of custom functions for plotting various data visualizations on Matlab.
If you want to try more in-depth vizualisation, I strongly recommend 
<a href="https://github.com/piermorel/gramm">Gramm</a>, which is fantastic for that purpose. In contrast, the purpose of this repository is to provide a
light, easy-to-use, and self-contained toolbox for quickly producing publication-friendly figures.

The optional argument syntax is identical across all functions, allowing fast and seamless switch between different
functions types and a smooth familiarization phase for new users.

Run `example_plots.m` to reproduce the example figures below.

## Plotting distributions

### Gauge plots for categorical distributions

The function ```gaugeplot.m``` produces bar plots with divisions proportional to categorical
groupings.

<img src="img\gaugeplot.png" alt="gaugeplot" width="250">

### Distribution plots for uni-dimensional continuous distributions

The function ```distline.m``` produces kernel-smoothed distributions on a one-dimensional
axis. The properties of the kernel can easily be adjusted using input arguments to the function.

<img src="img\distline.png" alt="distline" width="300">

### Distribution plots for two-dimensional continuous distributions

The function ```scatterdist.m``` produces scatter plots with projected
distributions on each axis. The Distributions can be "classic" histograms
or kernel-smoothed distributions. The properties of the kernel can easily be adjusted using input arguments to the function.

<img src="img\scatterdist.png" alt="scatterdist" width="500">

## Plotting group data

For all of the functions below, the mode and error interval can be defined by the user in the same way. Users can chose
between mean and median for the mode, and between standard deviation, standard error of the mean, and bootstraped
confidence interval of the chosen mode.

For all functions below, individual datapoints can be plotted with a user-defined layout:
- 'align' aligns all datapoints on an invisible line.
- 'deport' aligns all datapoints based on the data's cumulative distribution.
- 'jitter' jitters all datapoints according to their kernel-smoothed distribution. The properties of the kernel can
easily be adjusted using input arguments to the function.
- 'silo' jitters all datapoints randomly in a "silo-like" column.
- 'none' removes individual datapoints entirely.

You can see an illustration of each of these options in the figures below, in the same order (from left to right).

### Bar plots

The function ```barreplot.m``` produces typical barplots as used in most publications.

<img src="img\barreplot.png" alt="barreplot" height="200">

### Dot plots

The function ```dotplot.m``` produces barplots without the bars, just the dots.

<img src="img\dotplot.png" alt="dotplot" height="200">

### Boite plots

The function ```boiteplot.m``` produces typical boxplots as used in most publications. The mode and error interval can 
also be added alongside the quantile-providing boxplot. 

<img src="img\boiteplot.png" alt="boiteplot" height="200">

### Rain plots

The function ```rainplot.m``` produces rainplots, also sometimes called half-violin plots. The "cloud" is produced in a 
similar way as ```distlines.m```, using a kernel-smoothing distribution. The properties of the kernel can
easily be adjusted using input arguments to the function.

<img src="img\rainplot.png" alt="rainplot" height="200">





















