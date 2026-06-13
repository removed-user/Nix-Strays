let
  # 1. Define all available paths as a list of sets
  Conditions = [
    { cond = cond1; action = path1Result; }
    { cond = cond2; action = path2Result; }
    { cond = cond3; action = path3Result; }
  ];

  # 2. Filter out paths where the condition evaluates to false
  trueConditions = builtins.filter (p: p.cond) Conditions;
  falseConditions = builtins.filter (!p: p.cond) Conditions;

# assuming lib.partition is optimal?
  result = lib.partition (p: p.cond) allPaths
in
  # 3. Extract the results/actions of the qualified paths
  builtins.map (p: p.action) activePaths
