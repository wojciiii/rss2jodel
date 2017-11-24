#!/usr/bin/python
import sys
import getopt
import feedparser
import hashlib

name=sys.argv[0]
argv=sys.argv[1:]

def print_help():
    print 'Usage:\n%s -i <inputfile> -o <outputfile>' % name
    sys.exit(1)

if len(argv) == 0:
    print_help()

    
inputfile = ''
outputfile = ''
try:
    opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
except getopt.GetoptError:
    print_help()

for opt, arg in opts:
    if opt == '-h':
        print_help()
    elif opt in ("-i", "--ifile"):
        inputfile = arg
    elif opt in ("-o", "--ofile"):
        outputfile = arg

if len(inputfile) == 0 or len(outputfile) == 0:
    print_help()

print 'Input file is "', inputfile
print 'Output file is "', outputfile

f=open(inputfile, "r")
lines = [line.rstrip() for line in f.readlines()]
f.close()

with open(outputfile, "w") as wf:
    for line in lines:
        print(line)
        tag, url = line.split(',')
        print("Reading from feed: %s" % url)

        feed = feedparser.parse(url)
        for entry in feed['entries']:
            detail = entry['summary_detail']
            value = detail['value']

            toPrint = u''.join((value)).encode('utf-8').strip()
            # Get hash of the string to print:
            hash_object = hashlib.sha512(toPrint)
            hex_dig = hash_object.hexdigest()
            wf.write("%s:%s:%s\n" % (hex_dig, tag, toPrint))
    
