#!/bin/sh

srcdir=`dirname "$0"`

cd "$srcdir" || exit

exe=CoDMPServer_PC.exe

if test "x$COD_EXE" != "x"; then
	if test ! -e "$COD_EXE"; then
		echo "COD_EXE value: $COD_EXE: file does not exist"
		exit 1
	fi
	exe=$COD_EXE
fi

if test ! -e $exe; then
	echo "$exe not found in script directory"
	echo "Define the variable COD_EXE to provide the path to the T6 executable"
	exit 1
fi

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

"$PYTHON" --version || exit

# Run reflex on the T6 server debug executable, CoDMPServer_PC.exe
# This executable has:
#   - SHA256: ecede1035e091aaf45f358f5d7f73aa90f2a747027a13bf9906699d1121736cc
#   - BUILD_NUMBER: 4
#   - CHANGELIST_NUMBER: 1757733
#   - BUILD_TIME: Tue May 06 09:59:33 2014
# It can be acquired from this mega link:
# https://mega.nz/#!VUVATCDK!aHbD69iprnTDgvrvwTQD_LZ9fCWUZ06zltZkNhULT1M
"$PYTHON" "$REFLEXDIR/py/reflex.py" --accept 9076808 2 --base 9078576 2 \
--chk 9080576 2 --def 9079096 2 --ec 9077312 4 --meta 9078336 4 \
--nxt 9079616 2 --max-state 248 "$exe" $OUTDIR || exit

dot -Tpdf -o $OUTDIR/out.png $OUTDIR/1.dot || exit

"$PYTHON" "$REFLEXDIR/py/simplify.py" "$OUTDIR/G.gpickle" \
"$OUTDIR/simple/" || exit

sh "$REFLEXDIR/subs2pdf.sh" $OUTDIR/simple || exit

powershell -File "$srcdir/../jreflex.ps1" -Name "../dumptable/t6.txt" -Dir \
"$OUTDIR" -Reflex "$REFLEXDIR" || exit
