#!/bin/sh

outdir=$1
test "x$outdir" = x && outdir=.

outdir=`cd "$outdir" && pwd`

linker=${TA_GAME_PATH}bin/linker_modtools.exe

srcdir=`dirname "$0"`
srcdir=`cd "$srcdir" && pwd`

make -C "$srcdir" clean || exit

make -C "$srcdir" OUTDIR=$outdir || exit

make -C "$srcdir" install || exit

"$linker" -version

make -C "$srcdir" uninstall
echo "PYTHON=$PYTHON"
echo "REFLEX=$REFLEX"

cd "$outdir" || exit

langs="html scr scr_sym sproc"

for x in $langs; do
	OUTDIR=$x
	. ./dump_$x.sh || exit
	dot -Tpdf -o $x/out.png $x/1.dot || exit
	$PYTHON $REFLEX/py/simplify.py "$x/G.gpickle" "$x/simple/" || exit
	sh $REFLEX/subs2pdf.sh $x/simple || exit
	powershell -File "$srcdir/../jreflex.ps1" -Name "$x.txt" -Dir "$outdir/$x" -Reflex "$REFLEX" || exit
done
