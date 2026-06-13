# This has the benefit of simply/easily returning the attribute sets under the variable you set. 

```nix
let
  # 1. Define your checks using descriptive names as keys
  conditions = {
    checkDiskSpace = { cond = true;  action = "Clean disk"; };
    checkNetwork   = { cond = false; action = "Retry connection"; }; # Kept
    checkMemory    = { cond = false; action = "Allocate swap"; };     # Kept
  };

  # 2. Filter the attribute set to keep only elements where 'cond' is false

  failedChecks = builtins.filterAttrs (name: value: !value.cond) conditions;
in
  # 3. Access the actions or names of the remaining paths
  failedChecks
```


```md
returns this attset, which you can read from - to directly get the value of a given check
{
  checkNetwork = { cond = false; action = "Retry connection"; };
  checkMemory  = { cond = false; action = "Allocate swap"; };
}

```
