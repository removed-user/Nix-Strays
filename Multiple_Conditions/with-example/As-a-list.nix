# This has the benefit that checks have a strict ordering.
# You can have the action of each... be to continue/perform the next
# Which would give very efficient checking/conditional logic
let
  condition1 = x: builtins.isAttrs x;
  condition2 = x: builtins.isPath x;
  condition3 = x: builtins.isBool x;

  Action1 = x: "Attrs!";
  Action2 = x: "Path!";
  Action3 = x: "Bool!";

  # 1. Define all available paths as a list of sets
  Conditions = [
    {
      cond = condition1;
      action = Action1;
    }
    {
      cond = condition2;
      action = Action2;
    }
    {
      cond = condition3;
      action = Action3;
    }
  ];

  # 2. Filter out paths where the condition evaluates to false
  trueConditions = builtins.filter (p: p.cond) Conditions;
  falseConditions = builtins.filter (p: !p.cond) Conditions;

  # assuming lib.partition is optimal?
  result = lib.partition (p: p.cond) Conditions;
in
  # 3. Extract the results/actions of the qualified paths
  builtins.map (p: p.action) trueConditions
