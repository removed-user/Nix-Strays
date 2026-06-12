{lib, ... }:{
/**
    Get a path as a list if it exists.
    Returns an empty list if the path does not exist.
    Useful for adding optional paths to import statements.

    # Inputs

    `path`
    : The path to check for existence.

    # Type

    ```
    optionalPath :: Path -> [ Path ]
    ```

    # Examples

    ```nix
    optionalPath ./module.nix
    => [ ./module.nix ]
    optionalPath ./non-existing-module.nix
    => [ ]
    ```
  */
  optionalPath = path: if builtins.pathExists path then [ path ] else [ ];

  /**
    Check if a value of arbitrary type is empty.

    # Inputs

    `value`
    : The value to check for emptiness.

    # Type

    ```
    isEmpty :: Any -> Bool
    ```

    # Examples

    ```nix
    isEmpty ""
    => true
    isEmpty null
    => true
    isEmpty [ ]
    => true
    isEmpty { }
    => true
    isEmpty "foo"
    => false
    isEmpty [ "foo" ]
    => false
    isEmpty { foo = "bar"; }
    => false
    ```
  */
  isEmpty = value: value == null || value == "" || value == [ ] || value == { };

  /**
    Check if a value of arbitrary type is non-empty.
    Opposite of `isEmpty`.

    # Inputs

    `value`
    : The value to check for non-emptiness.

    # Type

    ```
    isNotEmpty :: Any -> Bool
    ```

    # Examples

    ```nix
    isNotEmpty ""
    => false
    ```
  */
  isNotEmpty = value: !isEmpty value;
}
