#!/bin/sh
# a quick fix for issue
#     http://gridengine.sunsource.net/issues/show_bug.cgi?id=2515
# place somewhere in your path - don't rely on the exit code

qhost $@ | sed -e 's/xmlns=/xmlns:xsd=/'
