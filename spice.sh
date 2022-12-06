#!/usr/bin/env bash
# EF1911 varmesystem model

# This is inspired by SPICE used for Electronic circuit simulation.
# We have Nodes which are junctions, and Components which span 2 or more junctions.
# Unlike SPICE, this is all made up in BASH, therefore can define cool things.
function comp {
  local name="${1}${COMP_CNT:-0}"
  local node_from="$2"
  local node_to="$3"
  shift 3
  local comment="$@"
  export COMP_CNT=$(( $COMP_CNT + 1 ))

  echo "$comment"
  echo "$name $OPTS"
  echo "$node_from -> $name"
  echo "$name -> $node_to"
  echo ""
}

function pipe {
  local name="${1}${COMP_CNT:-0}"
  local node_from="$2"
  local node_to="$3"
  shift 3
  local comment="$@"
  export COMP_CNT=$(( $COMP_CNT + 1 ))

  echo "$comment"
  echo "$node_from [shape=point]"
  echo "$node_from -> $node_to [label=\"$name\", penwidth=3, dir=none]"
}

function fork {
  local node_from="$1"
  shift

  echo "// Fork: $node_from splits in $#"
  for node_to in $@ ; do
    echo "$node_from -> $node_to"
  done
}

function string_down {
  local node_from="$1"
  local f="$node_from"
  for floor in {4..0} ; do
    t=${node_from}_${floor}
    pipe r${floor}p $f $t
    f=$t
  done
}

# Component NodeFrom NodeTo #Comment
pipe Rør Po P5         // Rør op til 5te sal

function opgang {
  local name="$1"
  local from="$2"
  local to="$3"
  pipe Rør $from M${name}  // Rør til Manifold ${name}
  fork M${name}  S${name}_kgA S${name}_kgB S${name}_yard
  string_down S${name}_kgA; pipe Rør S${name}_kgA_0 $to
  string_down S${name}_kgB; pipe Rør S${name}_kgB_0 $to
  string_down S${name}_yard; pipe Rør S${name}_yard_0 $to
}

opgang 37V P5 ret; opgang 37H P5 ret
opgang 42V P5 ret; opgang 42H P5 ret
opgang 44V P5 ret; opgang 44H P5 ret
opgang 95V P5 ret; opgang 95H P5 ret
opgang 97V P5 ret; opgang 97H P5 ret
opgang 99V P5 ret; opgang 99H P5 ret
opgang 101V P5 ret; opgang 101H P5 ret
opgang 103V P5 ret; opgang 103H P5 ret

pipe Rør ret Pi

comp Hovedpumpe Pi Po  // Cirkulationspumpe som flytter vandet rundt i et lukket loop
