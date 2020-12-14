import sys
import shutil
import subprocess

def runSimulation():
	bashCommand = "/home/isa37/git/lab2/script/start_synopsys"
	process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
	output, error = process.communicate()

def check_MET():
	datafile = "/home/isa37/git/lab2/syn/analysis_results/timing_results.txt"
	slackMet = False
	clockUncertainty = 0.0
	setupTime = 0.0
	arrivalTime = 0.0
	for line in open(datafile):
		if "data arrival time" in line:
			lineComponents = line.split()
			arrivalTime = lineComponents[3]
			print "data arrival time: " + str(arrivalTime)
		if "clock uncertainty" in line:
			lineComponents= line.split()
			clockUncertainty = lineComponents[2]
			print "clock uncertainty: " + str(clockUncertainty)

		if "library setup time"	in line:
			lineComponents= line.split()
			setupTime = lineComponents[3]
			print "library setup time: " + str(setupTime)
			
		
	       	if "slack" in line:
			if "MET" in line:
	               		slackMet = True
				break
	if slackMet:
		print "Slack is MET"
		return 0
	else:
		print "Slack is VIOLATED"
		return float(setupTime)+float(clockUncertainty)+float(arrivalTime)

	 

def update_clockValue(new_clock):
	out = open("/home/isa37/git/lab2/script/new_syntesis_with_clock.tcl", 'w')
	cnt=0;

	for line in open("/home/isa37/git/lab2/script/syntesis_with_clock.tcl"):
		if 'create_clock' in line and cnt==0:
			nuovo = 'create_clock -name MY_CLK -period '+ str(new_clock) +' clk\n'
			out.write(nuovo)
			cnt=1;
		else:
			out.write(line)

	out.close()
	shutil.move("/home/isa37/git/lab2/script/new_syntesis_with_clock.tcl","/home/isa37/git/lab2/script/syntesis_with_clock.tcl")

i=0
newClock = 1111
while (newClock!=0 and i<8):
	if newClock==1111 :
		print "Running first simulation... "
	else:
		print "Running simulation with clock: " + str(-newClock)
	runSimulation()

	newClock = check_MET()
	update_clockValue(-newClock)
	i+=1
	print "\n------------------------------------------------\n\n"
