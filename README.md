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

The simpliest form is to chdir to your KVIrc/log directory, then run the **all.sh** script, passing the current directory, and 
redirect output to a csv file. This will process all log files from the current directory. 

Note that this does not handle rotating log files, so make sure to clean up old entires prior to running the all.sh script, 
otherwise you will generate lots of old, invalid data. 

### Processing all log files

```
cd ~/.config/KVIrc/log
~/xdccbrowser/all.sh . > ~/xdcc-list.csv
```

### Processing single log files

Alternatively, you may pass the log file to stdin of parse.sh to generate CSV output. Remember to include the IRC network, 
and IRC channel as the first and second arguments to parse.sh (this is just for reference in the CSV - the names can be 
arbitrary). 

```
cd ~/.config/KVIrc/log
cat channel_#example_channel.example_network_2018_02_07.log
~/xdccbrowser/parse.sh example_network example_channel > example-xdcc.csv
```

### Using tabview

After generating the CSV, you can browser it however you want, but I prefer using tabview:
```
tabview --width 'mode' xdcc.csv
```

#### Tabview keys

<> Increase/decrease all column widths
,. Increase/decrease selected column width
Aa Sort by selected column (ascending / descending)
/  Keyword search

#### Hint

After adjusting the column view so it's readable, sort Descending (uppercase A) by DLs, then sort Ascending (lowercase a) by 
Type, to see the most popular XDCC's by category.





