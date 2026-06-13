# flatten.nix
{ lib }:
let
  # Helper to find how many 'prev' links exist deep inside an attrset
  findMaxPrevDepth = attrs:
    if builtins.hasAttr "prev" attrs && builtins.isAttrs attrs.prev then
      1 + findMaxPrevDepth attrs.prev
    else
      0;

  # baseName: The original package root (e.g., "tinycc")
  # currentDepth: How many 'prev' layers deep we currently are
  # maxDepth: The total number of 'prev' layers found for this package
  flattenAttrs = baseName: currentDepth: maxDepth: attrs:
    lib.concatMapAttrs (name: value:
      let
        isPrev = name == "prev";
        
        # Calculate parameters for the next iteration
        nextDepth = if isPrev then currentDepth + 1 else currentDepth;
        
        # If we are at the top level, discover the max depth for this package chain
        nextMaxDepth = if baseName == "" && builtins.isAttrs value then 
          findMaxPrevDepth value 
        else 
          maxDepth;

        # Track the name of the tool/file inside the attribute set
        nextBaseName = 
          if baseName == "" then name
          else if isPrev then baseName  # Keep the root name, don't append "-stageX" yet
          else "${baseName}/${name}";    # For other nested attributes like sub-tools

        # Calculate the chronological bootstrap stage
        stageNum = nextMaxDepth - nextDepth;
        
        # Format the final name cleanly only when we hit a derivation
        makeFinalKey = if nextDepth == 0 then nextBaseName else "${nextBaseName}-stage${toString stageNum}";
      in
      if lib.isDerivation value then
        { "${makeFinalKey}" = value; }
      else if builtins.isAttrs value then
        flattenAttrs nextBaseName nextDepth nextMaxDepth value
      else
        {}
    ) attrs;
in
flattenAttrs "" 0 0
