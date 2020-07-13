version:@[{TESTINGVERSION};0;"development"]
info:read0`:version.txt
paramparse:{(!).("S*";"=")0:hsym`$"version.txt"}[]
gitinfo:(enlist[`version]!enlist version),paramparse
