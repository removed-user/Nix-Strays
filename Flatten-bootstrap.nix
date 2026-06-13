# flatten.nix
{ lib }:
let
  # Helper to find how many 'prev' links exist deep inside an attrset
  findMaxPrevDepth = attrs:
    if builtins.hasAttr "prev" attrs && builtins.isAttrs attrs.prev then
      1 + findMaxPrevDepth attrs.prev
    else
      0;

  flattenAttrs = prefix: currentDepth: maxDepth: attrs:
    lib.concatMapAttrs (name: value:
      let
        isPrev = name == "prev";
        
        # Calculate depth parameters
        nextDepth = if isPrev then currentDepth + 1 else currentDepth;
        # If this is a new root package, calculate its specific max chain length
        nextMaxDepth = if prefix == "" && builtins.isAttrs value then findMaxPrevDepth value else maxDepth;

        # Calculate the actual bootstrap stage (e.g., max 4 - current 1 = Stage 3)
        stageNum = nextMaxDepth - nextDepth;

        currentKey = 
          if isPrev then 
            # If we hit a compiler or tool at this stage level, tag it
            "${prefix}-stage${toString stageNum}"
          else if prefix == "" then 
            name 
          else 
            "${prefix}/${name}";
      in
      if lib.isDerivation value then
        # If the root package itself is a derivation, name it cleanly.
        # Otherwise, assign it its calculated stage string.
        let
          finalKey = if isPrev then currentKey else if currentDepth > 0 then "${prefix}-stage${toString stageNum}" else currentKey;
        in
        { "${finalKey}" = value; }
      else if builtins.isAttrs value then
        flattenAttrs currentKey nextDepth nextMaxDepth value
      else
        {}
    ) attrs;
in
flattenAttrs "" 0 0
