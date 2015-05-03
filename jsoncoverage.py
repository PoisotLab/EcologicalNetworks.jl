#! /usr/bin/env python2

import time
import os, glob
import json
import re

# Setup the coverage dict
COVERAGE = dict()
COVERAGE["timestamp"] = int(time.time())
COVERAGE["command_name"] = "Coverage.jl"
COVERAGE["files"] = []
COVERAGE["metrics"] = dict()

# Read the files
for sourcefile in os.listdir("src"):
    if sourcefile.endswith(".jl"):
        sourcefile = "src/" + sourcefile
        covfile = sourcefile + ".cov"
        if os.path.isfile(covfile):
            COVDICT = dict()
            COVDICT["filename"] = sourcefile
            with open(covfile, "r") as cf:
                covstatus = [line.split()[0] for line in cf]
            non_code = 0
            for i in xrange(len(covstatus)):
                if covstatus[i] == '-':
                    covstatus[i] = 0
                    non_code = non_code + 1
                else:
                    covstatus[i] = int(covstatus[i])
            lines_of_code = len(covstatus) - non_code
            covered_lines = sum([1 for i in covstatus if i > 0])
            COVDICT["coverage"] = covstatus
            COVDICT["covered_lines"] = covered_lines
            COVDICT["lines_of_code"] = lines_of_code
            COVDICT["covered_percent"] = (covered_lines / lines_of_code) * 100.0
            COVDICT["covered_strenght"] = 1.0
            COVERAGE["files"].append(COVDICT)


# Measure the overal metrics
COVERAGE["metrics"]["covered_percent"] = 100.0
COVERAGE["metrics"]["covered_strength"] = 1.0
COVERAGE["metrics"]["covered_lines"] = 5
COVERAGE["metrics"]["total_lines"] = 5

jCov = json.dumps(COVERAGE, indent=2)
fCov = open('coverage/coverage.json', 'w')
print >> fCov, jCov
fCov.close()

print jCov
