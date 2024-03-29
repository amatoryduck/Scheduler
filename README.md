# UMUCTV Scheduler

This code is used to update and maintain the UMUCTV television station as well as update the online schedule for the station.

### Prerequisites

These are ruby and python files. If you do not have ruby or python installed on your machine you can open a terminal and run these commands:

```
sudo apt install ruby
sudo apt install python
```

### How to install
Open a terminal on your machine and type the following commands:
```
cd ~
git clone https://github.com/amatoryduck/Scheduler.git
```

### maker.rb

This ruby file can be run to create a .csv file that is readable by the HyperCaster at UMUC, which will schedule programming. To run this file open a terminal on your machine and run the following commands:
```
cd ~/Scheduler
ruby maker.rb
```
This will open up a command-line interface that allows you to create a schedule based on your input. First, you must select the shows you want to program by entering the number of the series into the command line and then pressing enter. After you have exausted the 24 30-minute chunks to schedule you must then enter a start and end date in the format: DD-MM-YYYY. Once you do this you will have a file in your directory called maker.csv, which you can input into the HyperCaster.

### changer.rb

This ruby file takes in the x_list file generated from the HyperCaster, and outputs a file that is readable by the old system that generates the online schedule. To run this file you should make sure you have a x_list file in the scheduler folder, then open up a terminal and run the following commands:

```
cd ~/Scheduler
ruby changer.rb
```
This will generate a file in the scheduler folder called out.txt, which can be inputed into the online scheduler.

### texer.py

This is a python file that will generate a .txt file, that can generate a pdf of the schedule from out.txt. In order to run this file you should make sure you have a out.txt file in your scheduler folder, then open a terminal on your machine and run the following commands:

```
cd ~/Scheduler
python texer.py
```

This will generate a file called outtex.txt, which you can copy and paste into a online latex editor like Overleaf.com, which will generate a nice pdf of the schedule given by out.txt.

### shows.csv

This is a .csv file that has the name of all the series that can be scheduled. The format is: 
```
<Name of Series>,<Number of 30-minute chunks it requires>,<Episode Name>,<Previous Episode Time in Seconds>,
```
The last two columns should be repeated for every show in the series. To add a new episode to a series all you have to do is add the last two columns for each new episode in a series, and to add a new series you should add a new row, then put in the name of the new series, how many 30-minute chunks it takes, then its list of episodes. Note: make sure you do not have an empy line at any point in the file, it will break changer.rb.

## Authors

* **Alexander Scott** - [amatoryduck](https://github.com/amatoryduck)
