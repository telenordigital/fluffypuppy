#!/usr/bin/env python
# script should be saved in -s location (scout2 framework root)
import datetime
import shutil
import glob
import os
import argparse
import time
import sys
from subprocess import call

parser = argparse.ArgumentParser(description='Automates execution of Fluffy Puppy on a set of AWS accounts.')
parser.add_argument('-c', '--config', type=str, required=True, help='path to the AWS config')
parser.add_argument('-s', '--scout2', type=str, required=True, help='path to the Scout2 framework')
parser.add_argument('-t', '--sleeper', type=int, required=True, help='Amount of time (hours) the scan should rerun')
args = parser.parse_args()

aws_profiles = []
aws_config = os.path.normpath(args.config)
scout2 = os.path.normpath(args.scout2)
sleeper = args.sleeper
# converting hours into seconds
sleeper = sleeper * 60 * 60

if not os.path.exists(aws_config):
    sys.exit("error: AWS config path does not exist.")
elif not os.path.exists(scout2):
    sys.exit("error: SCOUT2 path does not exist.")

def fluffyPuppy():
    # creates a new directory to store backup
    newdir = os.path.join(scout2 + os.sep + 'scout2-report/inc-awsconfig/', datetime.datetime.now().strftime('%Y-%m-%d'))
    if not os.path.exists(newdir):
        os.makedirs(newdir)

    # copies files to new directory
    for file in glob.glob(scout2 + os.sep + 'scout2-report/inc-awsconfig/aws_config*.js'):
        shutil.copy(file, newdir)

    # parse .aws/config and creates list of aws profile names
    with open(aws_config, 'r') as config:
        for line in config:
            list_of_words = line.split()
            if '[profile' in list_of_words and \
                list_of_words[1][:-1] != 'default' and \
                list_of_words[1][:-1] != '[profil':
                    aws_profiles.append(list_of_words[1][:-1])

    # build system command
    os_cmd = "Scout2 --force --no-browser"

    # run scout2 while looping through .aws/config
    for profile in aws_profiles:
        print "SCANNING " + profile
        os.system(os_cmd + " --profile " + profile + " --ruleset custom-ruleset.json")

while True:
    fluffyPuppy()
    time.sleep(sleeper)
