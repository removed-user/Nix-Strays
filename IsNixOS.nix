{ config, options, lib, ... } @ args:

let
  # 1. Check if nixosConfigurations exists, is not null, and has elements
  hasNixosConfigs = 
    args ? nixosConfigurations 
    && args.nixosConfigurations != null 
    && args.nixosConfigurations != {};

  # 2. Check if a generic options or config system object is valid and populated
  hasValidSystem = 
    args ? system 
    && args.system != null 
    && args.system != {};

  # Combined cannot-fail check
  isNixOSContext = hasNixosConfigs || hasValidSystem;
in {
  # Your module logic here...
}
