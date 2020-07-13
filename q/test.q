// Retrieve all the information about the github repo we have generated
gitinfo:{@[(!).("S*";"=")0:hsym`$;"version.txt";{"Generate version.txt using 'cmake -P gitversion.cmake' from repo root"}]}

// Retrieve any potentially useful information about the kdb version/system information
qinfo:`qversion`qrelease`os!(.z.K;.z.k;.z.o)

// Consolidate the information about git and q
repoinfo:{@[qinfo,;gitinfo[];{show qinfo;gitinfo[]}]}
