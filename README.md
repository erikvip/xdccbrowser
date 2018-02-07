# XDCC CSV Browser / parser

Small shell script for merging KVIrc log files and parsing out XDCC offerings into a CSV file, 
which can then be read using CSV viewer (like tabview: https://github.com/TabViewer/tabview )

## Installation

### Log file requirements

You must enable the boolStripControlCodesInLogs flag to strip color codes from the log files, 
otherwise the parser will not generate output. 

From KVIRc, run this command in any window:
```
/option boolStripControlCodesInLogs 1
```

or set ***boolStripControlCodesInLogs=true** in your **config/main.kvc** file.

## Usage

The simpliest form is to run the **all.sh** script. This will check the default KVIrc log location, and parse channel log files
created within the past 5 days. If your log files are not in the default location, pass the log directory as the first argument to **all.sh**.

CSV data will be sent to STDOUT, so remember to redirect the output to a CSV File. 

### Processing all log files

```
# Default location
~/xdccbrowser/all.sh > ~/xdcc-list.csv

```

### Processing single log files

Alternatively, you may pass the log file to stdin of parse.sh to generate CSV output. Remember to include the IRC network, 
and IRC channel as the first and second arguments to parse.sh (this is just for reference in the CSV - the names can be 
arbitrary). 

```
cd ~/.config/KVIrc/log
cat channel_#example_channel.example_network_2018_02_07.log
~/xdccbrowser/parse.sh example_network example_channel > ~/xdcc-list.csv
```

### Using tabview

After generating the CSV, you can browser it however you want, but I prefer using tabview:
```
tabview --width 'mode' xdcc.csv
```

#### Hint

After adjusting the column view so it's readable, sort Descending (uppercase A) by DLs, then sort Ascending (lowercase a) by 
Type, to see the most popular XDCC's by category.





