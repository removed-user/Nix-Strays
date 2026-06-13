# This has the benefit that checks have a strict ordering.
# You can have the action of each... be to continue/perform the next
# Which would give very efficient checking/conditional logic
{lib, ...}: let
  # example Conditions (check type)
  checks = {y, ...}: {
    cond1 = builtins.isString y;
    cond2 = builtins.isBool y;
    cond3 = builtins.isAttrs y;
  };
  # example functions (print string)
  Action1 = z: "String!";
  Action2 = z: "Bool!";
  Action3 = z: "Attrs!";

  # 1. Define all available Code Paths as a list of sets
  Conditions = [
    {
      cond = checks.cond1;
      action = Action1;
    }
    {
      cond = checks.cond2;
      action = Action2;
    }
    {
      cond = checks.cond3;
      action = Action3;
    }
  ];

  # 2. Filter out paths where the condition evaluates to false
  trueConditions = builtins.filter (p: p.cond) Conditions;
  falseConditions = builtins.filter (p: !p.cond) Conditions;

  # assuming lib.partition is optimal?
  result = lib.partition (p: p.cond) Conditions;
in
  # 3.Get results/take actions on the selected paths
  {
    truthyActions = builtins.map (p: p.action) trueConditions;
    falseyActions = builtins.map (p: p.action) falseConditions;
    right = result.right;
    wrong = result.wrong;
  }
