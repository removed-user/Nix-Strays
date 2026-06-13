# =========================================================================
# LAYER 1: The Base Conditions
# =========================================================================

```nix
let
  
  layer1 = {
    checkDisk   = { cond = false; action = "Clean disk"; };
    checkNetwork= { cond = true;  action = "Configure proxy"; };
    checkMemory = { cond = false; action = "Tune heap"; };
    checkCpu    = { cond = true;  action = "Throttling active"; };
  };

  # Helper shorthand to quickly grab the boolean true/false state from Layer 1
  # e.g., status "checkDisk" returns false
  status = name: layer1.${name}.cond;
```
  # =========================================================================
  # LAYER 2: Meta-Conditions (Checking arbitrary Layer 1 groups)
  # =========================================================================

```nix
  layer2 = {
    # Match if ALL specified Layer 1 conditions are false
    criticalInfrastructureFailed = {
      cond = builtins.all (name: !status name) [ "checkNetwork" "checkMemory" ];
      action = "Trigger full system rollback";
    };

    # Match if ANY of the specified Layer 1 conditions are false
    hardwareWarning = {
      cond = builtins.any (name: !status name) [ "checkDisk" "checkMemory" "checkCpu" ];
      action = "Email sysadmin warning log";
    };

    # Match a completely custom, arbitrary combination
    mixedState = {
      cond = (!status "checkDisk") && (status "checkNetwork");
      action = "Execute hybrid migration path";
    };
  };
```
  # =========================================================================
  # EXECUTION: Filter out the layers to find where 'cond' evaluates to false
  # =========================================================================

```nix

  failedLayer1 = builtins.filterAttrs (name: value: !value.cond) layer1;
  failedLayer2 = builtins.filterAttrs (name: value: !value.cond) layer2;

in
  {
    # You can return either layer, or both combined depending on your routing needs
    inherit failedLayer1 failedLayer2;
  }
  ```
