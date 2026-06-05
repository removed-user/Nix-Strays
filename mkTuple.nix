### Unfinished; add logic for each native type, and 
### optimally make a functor that directly returns lib.types.is$x depending on string given
let
  # 1. Mocked Type Definitions
  lib.types = {
    str = { name = "string"; };
    int = { name = "int"; };
    bool = { name = "bool"; };
  };

  # 2. Factored-out Component: Strictly handles the state calculations
  tupleConstructor = { total, previousRemaining, acc, currentType }:
    let
      # Both are defined and calculated directly inside the function body
      remaining = previousRemaining - 1;
      currentIndex = total - previousRemaining;
      
      # Build the updated ordered list
      updatedAcc = acc ++ [ currentType ];
    in
    if remaining == 0 then
      # Base Case: No steps left, return the final list directly
      updatedAcc
    else
      # Recursive Case: Return a function waiting for the next space-separated argument
      nextType: tupleConstructor {
        inherit total acc;
        previousRemaining = remaining;
        currentType = nextType;
      };

  # 3. Entry Point
  mkTuple = total: 
    # Accepts the first type argument right after the size integer
    firstType: tupleConstructor {
      inherit total;
      previousRemaining = total;
      acc = [ ];
      currentType = firstType;
    };

  # --- Lazy Scope Setup ---
  string = lib.types.str;
  int    = lib.types.int;
  bool   = lib.types.bool;
in

  # No loops, no lists, just space-separated arguments!
  mkTuple 3 string int bool

# Evaluates perfectly to:
# [ { name = "string"; } { name = "int"; } { name = "bool"; } ]
