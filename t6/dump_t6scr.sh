#!/bin/sh

srcdir=`dirname "$0"`

cd "$srcdir" || exit

import_makefile_vars() {
	file=$1
	shift
	for v; do
		eval "$v=\`sed -n -e '/^$v=/s/$v=//p' < $file\`"
	done
	for v; do
		eval "echo $v=\$$v"
	done
}

import_makefile_vars Makefile PYTHON FLEX CC REFLEXDIR

OUTDIR=dump

"$PYTHON" --version

"$PYTHON" "$REFLEXDIR/py/reflex.py" --accept 9076808 2 --base 9078576 2 --chk 9080576 2 --def 9079096 2 --ec 9077312 4 --meta 9078336 4 --nxt 9079616 2 --max-state 248 "C:/projects/research/linker/reflex/t6/CoDMPServer_PC.exe" $OUTDIR || exit

dot -Tpdf -o $OUTDIR/out.png $OUTDIR/1.dot || exit

"$PYTHON" "$REFLEXDIR/py/simplify.py" "$OUTDIR/G.gpickle" "$OUTDIR/simple/" || exit

sh "$REFLEXDIR/subs2pdf.sh" $OUTDIR/simple || exit

powershell -File "$srcdir/../jreflex.ps1" -Name "../dumptable/t6.txt" -Dir "$OUTDIR" -Reflex "$REFLEXDIR" || exit
