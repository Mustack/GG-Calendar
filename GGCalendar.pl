#!/usr/local/bin/perl


##########################################
# ============= GG Calendar ==============
#
# To use this script, first you must copy
# and paste your schedule from Infoweb and
# put it in a text file named infoweb.txt
# in the same directory as the script.
# Run the script without parameters and it
# will generate google.csv which you can
# upload to google calendar. As of now
# the script will only generate the first
# week of classes. To make events recurring,
# you must do so manually.
#
#
#
# ** Future Plans **
#
# -option to specify the input text file
# -adapt this script to generate iCal file (presently hardcoded)
# -find and use a cleaner way to exit the script
# -detect semester and date of first Monday
# -add google calendar functionality to upload automatically
#
##########################################


open(INFOWEB, "infoweb.txt");
open(GOOGLE, ">google.csv");

#This prints the headers of the csv file
print GOOGLE "Subject,Start Date,Start Time,End Date,End Time,All Day Event,Description,Location,Private\n";

#These are hardcoded dates for winter semester and Jan 9th being the first Monday.
$date = "01//12";
$firstMonday = 9;
%weekday = ("Monday" => 0, "Tuesday" => 1, "Wednesday" => 2, "Thursday" => 3, "Friday" => 4);

$line = <INFOWEB> or die;

while (true) {
	###################
	# Course Title Line
	###################
	$line =~ /((\w+ \w)|(\w+)) (\w\w.*) \Q(\E.*/; #we seperate the line
	
	$courseCode = $1; #the first group is the course code
	$courseName = $4; #the 4th group is the course name
	
	##################
	# Proffessor Line
	##################
	$line = <INFOWEB> or die;
	$line =~ /Prof: (\w+), (\w+)/;
		
	$prof = "$2 $1";
	
	#####################
	# Class Time Lines
	#####################
	$line = <INFOWEB> or die;
	while ($line =~ /(Monday|Tuesday|Wednesday|Thursday|Friday).*/) {
		$line =~ /(Monday|Tuesday|Wednesday|Thursday|Friday)\s+(\w+).*\s+(\d\d):(\d\d)-(\d\d):(\d\d)\s+(\w+)\s+Room: (\w+)/;
		
		### Get Date ###
		$courseDate = $date;
		#This will insert the date in the middle of the month and year.
		substr($courseDate, 3, 0) = $firstMonday + $weekday{$1};
		
		### Get Class Type (LEC, LAB, TUT...) ###
		$classType = $2;
		
		### Get Start Time ###
		if ($3 > 12) {
			$startTime = ($3 - 12).":".$4.":00 PM";
		} else {
			$startTime = $3.":".$4.":00 AM"; }
		
		### Get End Time ###
		if ($5 > 12) {
			$endTime = ($5 - 12).":".$6.":00 PM";
		} else {
			$endTime = $5.":".$6.":00 AM"; }
			
		
		### Get Location ###
		$location = "$7 $8";
		
		print GOOGLE "$classType - $courseName,$courseDate,$startTime,$courseDate,$endTime,False,$courseCode / $prof,$location,False\n";
		
		#Get the next line ready
		$line = <INFOWEB> or die;
		#print GOOGLE "$courseCode\n$classType - $courseName\n$prof\n$courseDate\n$startTime - $endTime\n$location\n";
	}
	
     }