# Nixpkgs Recursive Attribute Set Functions

## Mapping and Transformation
* `lib.attrsets.mapAttrsRecursive`: Applies a mapping function to every non-attribute-set "leaf" value. The function receives the full attribute path (as a list of strings) and the leaf value.
* `lib.attrsets.mapAttrsRecursiveCond`: Like `mapAttrsRecursive`, but takes a predicate function (`cond`) as its first argument. It only recurses into an attribute set if `cond` returns true; otherwise, it treats the set as a leaf.
* `lib.attrsets.mapAttrsToListRecursive`: Recurses through the tree to find all leaf values, maps over them, and flattens the results into a single lexicographically ordered list.

## Filtering
* `lib.attrsets.filterAttrsRecursive`: Recursively filters an attribute set by removing any attribute where a predicate function (checking name and value) returns false.

## Merging and Updating
* `lib.attrsets.recursiveUpdate`: A deep version of the standard Nix `//` operator. It recursively merges nested attribute sets until a value on either side is not a set, with the right-hand side taking precedence.
* `lib.attrsets.recursiveUpdateUntil`: An extension of `recursiveUpdate` that takes a predicate function to determine exactly when the recursive merging should stop.
* `lib.attrsets.updateManyAttrsByPath`: Takes a list of specific attribute paths and update modifiers, recursing down into the set to apply changes deep within the structure.

## Path-based Traversal Utilities
* `lib.attrsets.attrByPath`: Traverses a specified path (e.g., `["a" "b"]`) into a nested set and returns the value, or a default fallback if the path does not exist.
* `lib.attrsets.hasAttrByPath`: Recursively checks whether a specific attribute path exists in a nested set, returning a boolean.
* `lib.attrsets.setAttrByPath`: Recursively constructs a nested attribute set structure to place a single value at the end of a given path.
