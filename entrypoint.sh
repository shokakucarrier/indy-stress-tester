set -x
jmeter -n -t ./tests/$1 -S ./inputs/properties/$2 -l ./$(basename $1).log
