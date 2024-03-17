{ lib, ... }:
{
  flake.lib = rec {
    compose = f: g: x: f (g x);

    mapListToAttrs' = f: list: builtins.listToAttrs (map f list);
    mapListToAttrs = f: mapListToAttrs' (x: lib.nameValuePair x (f x));

    concatMapAttrsToList = f: a: lib.concatLists (lib.mapAttrsToList f a);
  };
}
