#!/bin/sh

scriptdir=`dirname "$0"`
script=$0

PYTHON=${PYTHON-python}
REDIR=.
exe=example.exe
source=lex.yy.c
outdir=output
outfile=

error() {
	echo "$script: $*"
	exit 1
}

test_exist() {
	test -e "$1" || error "$1 does not exist"
}

test_prog() {
	"$1" --version >/dev/null 2>&1 || error "$1 is invalid"
}

while test "x$1" != x; do
	case $1 in
		--exe=*) exe=${1#*=};;
		--outdir=*|--out-dir=*|--output-dir=*) outdir=${1#*=};;
		--outfile=*|--out-file=*|--output=*) outfile=${1#*=};;
		--py=*|--python=*) PYTHON=${1#*=};;
		--reflexdir=*|--reflex-dir=*) REDIR=${1#*=};;
		--source=*) source=${1#*=};;
		*) error "Unrecognized argument: '$1'";;
	esac
	shift
done

test_prog "$PYTHON"
test_exist "$REDIR/py/reflex.py"

args=

size_default=2
size_ec=4
size_meta=4

dataoffs=`objdump --section=.rdata -h "$exe" | \
sed -n 's/^[^.]*\.rdata[ 	][ 	]*[0-9a-zA-Z][0-9a-zA-Z]*[ 	][ 	]*[ 	][ 	]*[0-9a-zA-Z][0-9a-zA-Z]*[ 	][ 	]*[0-9a-zA-Z][0-9a-zA-Z]*[ 	][ 	]*\([0-9a-zA-Z][0-9a-zA-Z]*\).*$/\1/p'`

for s in accept base chk def ec meta nxt; do
	# section offset
	secoffs=`objdump -t "$exe" | grep yy_$s | \
	sed 's/^.*0x\([0-9a-zA-Z][0-9a-zA-Z]*\)[ 	][ 	]*yy_.*$/\1/'`
	addr=`printf '%x\n' $((0x$dataoffs+0x$secoffs))`
	eval size=\$size_$s
	test x$size = x && size=$size_default
	args="$args --$s 0x$addr $size"
done

max_state=`sed -n -e \
's/^static yyconst short int yy_accept\[\([0-9][0-9]*\)\].*$/\1/p' < $source`

max_state=$((${max_state}-1))

rm -rf "$outdir"

args="$args --max-state $max_state $exe $outdir"

$PYTHON $REDIR/py/reflex.py $args || exit

dot -Tpdf -o "$outdir/out.png" "$outdir/1.dot" || exit

$PYTHON $REDIR/py/simplify.py "$outdir/G.gpickle" "$outdir/simple/" || exit

sh $REDIR/subs2pdf.sh "$outdir/simple"

test "x$outfile" = x && outfile=$outdir/$exe.txt

powershell -File "$scriptdir/jreflex.ps1" -Name "$outfile" -Dir "$outdir" -Reflex "$REDIR"
