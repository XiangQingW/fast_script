#!/bin/python

import re
import sys

def replace(file_name, from_str, to_str):
    regex = re.compile(r"(?<!\w){str}(?!\w)".format(str=from_str))

    filedata = None
    with open(file_name, 'r') as file:
      filedata = file.read()
    new = regex.sub(to_str, filedata)

    with open(file_name, 'w') as file :
      file.write(new)

(file_name, from_str, to_str) = (sys.argv[1], sys.argv[2], sys.argv[3])
replace(file_name, from_str, to_str)
