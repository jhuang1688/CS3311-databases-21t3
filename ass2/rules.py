#!/usr/bin/python3
# COMP3311 21T3 Ass2 ... print list of rules for a program or stream

import sys
import psycopg2
import re
from helpers import getProgram, getStream

from helpers import *

# define any local helper functions here
# ...

### set up some globals

usage = f"Usage: {sys.argv[0]} (ProgramCode|StreamCode)"
db = None

### process command-line args

argc = len(sys.argv)
if argc < 2:
  print(usage)
  exit(1)
code = sys.argv[1]
if len(code) == 4:
  codeOf = "program"
elif len(code) == 6:
  codeOf = "stream"

try:
  db = psycopg2.connect("dbname=mymyunsw")
  if codeOf == "program":
    progInfo = getProgram(db,code)
    if not progInfo:
      print(f"Invalid program code {code}")
      exit()
    #print(progInfo)  #debug
    # List the rules for Program

    # ... add your code here ...
    # print(progInfo)
    
    years = progInfo[6] / 12
    print(f"{progInfo[0]} {progInfo[2]}, {progInfo[3]} UOC, {years} years")
    programDetails = getProgramSchool(db,code)
    print(f"- offered by {programDetails[0]}")

    # Academic Requirements:
    print("Academic Requirements:")

    rules = getProgramRules(db,code)

    # List of streams
    streams = getCodeStream(db)
    streamCodes = []
    for streamCode in streams:
      streamCodes.append(streamCode[0])

    # List of Subjects
    subjects = getCodeSubjects(db)
    subjectCodes = []
    for subjectCode in subjects:
      subjectCodes.append(subjectCode[0])
    
    for rule in rules:
      ruleType = rule[2]
      minReq = rule[3]
      maxReq = rule[4]

      definition = rule[13]
      l = definition.split(',')

      if ruleType == "DS":
        print(f"{rule[3]} stream(s) from {rule[1]}")
        for stream in l:
          name = getStreamName(db, stream)
          if stream in streamCodes:
            print(f"- {stream} {name}")
          else:
            print(f"- {stream} ???")    
      elif ruleType == "CC":
        if len(l) == 1:
          print(rule[1])
        else:
          print(f"all courses from {rule[1]}")
        for subject in l:
          # Or requirement
          if re.match(r'{[A-Z]{4}[0-9]{4};[A-Z]{4}[0-9]{4}}', subject):
            subject = subject.lstrip("{").rstrip("}")
            a, b = subject.split(';')
            nameA = getSubjectName(db, a)
            nameB = getSubjectName(db, b)
            print(f"- {a} {nameA}")
            print(f"  or {b} {nameB}")
            continue
          name = getSubjectName(db, subject)
          if subject in subjectCodes:
            print(f"- {subject} {name}")
          else:
            print(f"- {subject} ???")
      elif ruleType == "GE":
        print(f"{maxReq} UOC of {rule[1]}")

  elif codeOf == "stream":
    strmInfo = getStream(db,code)
    if not strmInfo:
      print(f"Invalid stream code {code}")
      exit()
    #print(strmInfo)  #debug
    # List the rules for Stream
    # ... add your code here ...
    # print(strmInfo) 

    print(f"{strmInfo[1]} {strmInfo[2]}")
    streamDetails = getStreamSchool(db, strmInfo[3])
    print(f"- offered by {streamDetails[0]}")

    # Academic Requirements:
    print("Academic Requirements:")

    rules = getStreamRules(db, code)

    # List of streams
    streams = getCodeStream(db)
    streamCodes = []
    for streamCode in streams:
      streamCodes.append(streamCode[0])

    # List of Subjects
    subjects = getCodeSubjects(db)
    subjectCodes = []
    for subjectCode in subjects:
      subjectCodes.append(subjectCode[0])

    for rule in rules:
      ruleName = rule[1]
      ruleType = rule[2]
      minReq = rule[3]
      maxReq = rule[4]

      aogGroup = rule[12]

      definition = rule[13]
      l = definition.split(',')

      if ruleType == "FE":
        ruleName = "Free Electives"
        if minReq is None and maxReq is None:
          print(ruleName)
        elif minReq is not None and maxReq is None:
          print(f"at least {minReq} UOC of {ruleName}")
        elif minReq is None and maxReq is not None:
          print(f"up to {maxReq} UOC of {ruleName}")
        elif minReq < maxReq:
          print(f"between {minReq} and {maxReq} UOC of {ruleName}")
        elif minReq == maxReq:
          print(f"{minReq} UOC of {ruleName}")

      if ruleType != "FE":
        if minReq is None and maxReq is None:
          print(ruleName)
        elif minReq is not None and maxReq is None:
          print(f"at least {minReq} UOC courses from {ruleName}")
        elif minReq is None and maxReq is not None:
          print(f"up to {maxReq} UOC courses from {ruleName}")
        elif minReq < maxReq:
          print(f"between {minReq} and {maxReq} UOC courses from {ruleName}")
        elif minReq == maxReq:
          print(f"{minReq} UOC courses from {ruleName}")
      
      for subject in l:
        if aogGroup == "pattern":
          if ruleType == "PE":
            print(f"- courses matching {definition}")
          break

        # Or requirement
        if re.match(r'{[A-Z]{4}[0-9]{4};[A-Z]{4}[0-9]{4}}', subject):
          subject = subject.lstrip("{").rstrip("}")
          a, b = subject.split(';')
          nameA = getSubjectName(db, a)
          nameB = getSubjectName(db, b)
          print(f"- {a} {nameA}")
          print(f"  or {b} {nameB}")
          continue

        name = getSubjectName(db, subject)
        if subject in subjectCodes:
          print(f"- {subject} {name}")
        else:
          print(f"- {subject} ???")

      # print(rule)
      # print()

except Exception as err:
  print(err)
finally:
  if db:
    db.close()
