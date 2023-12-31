{ lib, ... }:

with builtins;
with lib;

rec {
  attrsToList = attrs;
    mapAttrsToList (name: value: { inherit name value; }) attrs;

    # mapFilterAttrs ::
    #  (name -> value -> bool)
    #  (name -> value -> { name = any; value = any; })
    #  attrs
    mapFilterAttrs = pred: f: attrs: filterAttrs pred (mapAttrs' f attrs);

    # Generate attribute set by map funct over value list
    genAttrs' = values: f: list ToAttrs (map f values);

    # anyAttrs :: (name -> value -> bool) attrs
    anyAttrs = pred: attrs:
    any (attr: pred attr.name attr.value) (attrsToList attrs);

    # countAttrs :: (name -> value -> bool) attrs
    countAttrs = pred: attrs:
    count (attr: pred attr.name attr.value) (attrsToList attrs);
}