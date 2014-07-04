import sys, re
file = sys.argv[1]
libpath = sys.argv[2]
print "   patching ", file

with open(file, 'r') as f:
    s = f.read()
s = re.sub(r';(hdf5[a-zA-Z0-9_]*)', ';' + libpath + r'/\1.lib', s)
with open(file, 'w') as f:
    f.write(s)
