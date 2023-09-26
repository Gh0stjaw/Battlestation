{ inputs, system }:

{
  with inputs;

  let
  cowsayOverlay = f: p: {
    inherit (inputs.cowsay.packages.${system}) cowsay;
  };
  
}