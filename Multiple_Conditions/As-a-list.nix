# This has the benefit that checks have a strict ordering. 
# You can have the action of each... be to continue/perform the next
# Which would give very efficient checking/conditional logic

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
  result = lib.partition (p: p.cond) Conditions
in
  # 3. Extract the results/actions of the qualified paths
  builtins.map (p: p.action) trueConditions
