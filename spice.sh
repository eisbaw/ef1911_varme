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
  echo ""
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
pipe Rør P5 M37H       // Rør til Manifold KG37 Højre
pipe Rør P5 M37V       // Rør til Manifold KG37 Venstre

fork M37H  S37H_kgA S37H_kgB S37H_yard
string_down S37H_kgA; pipe Rør S37H_kgA_0 ret
string_down S37H_kgB; pipe Rør S37H_kgB_0 ret
string_down S37H_yard; pipe Rør S37H_yard_0 ret

fork M37V  S37V_kgA S37V_kgB S37V_yard
string_down S37V_kgA; pipe Rør S37V_kgA_0 ret
string_down S37V_kgB; pipe Rør S37V_kgB_0 ret
string_down S37V_yard; pipe Rør S37V_yard_0 ret

pipe Rør ret Pi

comp Hovedpumpe Pi Po  // Cirkulationspumpe som flytter vandet rundt i et lukket loop

