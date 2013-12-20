#-------------------------------------------------------------------------------
# Name:        LDP_Parser
# Purpose:
#
# Author:      Sudeep Gowrishankar
#
# Created:     12/08/2013
# Copyright:   (c) Sudeep Gowrishankar 2013
# Licence:     <your licence>
#-------------------------------------------------------------------------------

def main():
    counts, times = parseFile("VISSIM_CONVEX.ldp")
    createCSV(counts, times, "SimulatedIntersection.csv")


def parseFile(filename):
    counts = [-1]
    times = [0]
    thousands = "000"
    print(thousands)
    currentPhase = 1
    phase1 = "I"
    phase2 = "."
    ldpFile = open(filename, "r")
    for columns in ( row.strip().split() for row in ldpFile ):
        if len(columns) >= 2:
            if "." in columns[0]:
                maneuvers = list(columns[0])
                for digit in range(0,10):
                    if columns[1][digit] is ".":
                        timestamp = str(columns[1][0:digit+2])
                        s = float(timestamp)
                        t = s*1000
                        break
                for detector in range(0,len(maneuvers)):
                    if maneuvers[detector] is "|" or maneuvers[detector] is "+":
                        counts.append(str(detector + 1))
                        times.append(str(t))
                for digit in range(0,10):
                    if columns[1][digit] is ".":
                        timestamp = str(columns[1][0:digit+2])
                        s = float(timestamp)
                        t = s*1000
                        tempPhase1 = str(columns[1][digit+2])
                        tempPhase2 = str(columns[1][digit+3])
                        if (currentPhase == 1) and (phase2 is not tempPhase2):
                            counts.append(str(-1))
                            times.append(str(t))
                            phase1,phase2 = switchPhaseLabels(phase1,phase2)
                            currentPhase = 2
                        elif (currentPhase == 2) and (phase1 is not tempPhase1):
                            counts.append(str(-1))
                            times.append(str(t))
                            phase1,phase2 = switchPhaseLabels(phase1,phase2)
                            currentPhase = 1
                        break
    return counts, times

def createCSV(counts, times, filename):
    import csv
    list(str(1))
    myfile = open(filename, 'wb')
    wr = csv.writer(myfile,dialect='excel')
    for row in range(0,len(counts)):
        wr.writerow(list(str(1))+[counts[row]]+[times[row]])

def switchPhaseLabels(phase1, phase2):
    temp = phase1
    phase1 = phase2
    phase2 = temp
    return phase1, phase2


if __name__ == '__main__':
    main()
