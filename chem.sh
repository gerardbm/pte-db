#!/usr/bin/env bash
# Version: 1.0.0
#
# Description: Get information on a element in the periodic table
#
# Tools used:
# - recutils
# - groff
# - fzf

FORMAT="A:box \"\fB{{Symbol}}\fP\" \"{{Name}}\" \"{{AtomicMass}}\" \"{{ElectronConfiguration}}\" wid 3 ht 4
B:box invis  \"{{AtomicNumber}}\" at (A.w.x + 0.5, A.e.y)
C:box \"{{OxidationStates}}\" invis at ((A.e.x - 0.5), (A.n.y - 0.3))"

CURRDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CHEMREC="$CURRDIR/chem.rec"

TYPE=$(printf 'Symbol\nName\n' | fzf)
SYMBOL=$(recsel -C "$CHEMREC" -P "$TYPE" | fzf --preview "recsel -e '$TYPE=\"{}\"' $CHEMREC")

format() {
  echo .PS
  recsel -e "$TYPE = '$SYMBOL' " "$CHEMREC" | recfmt "$FORMAT"
  printf '\n.PE'
}

format | pic -Tascii | nroff | sed -e '/^$/d'
