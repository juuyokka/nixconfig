{
  programs.firefox = {
    enable = true;
    profiles.lactose = {
      bookmarks = [
        {
          name = "Nix and NixOS";
          bookmarks = [
            { name = "NixOS Package Search"; url = "https://search.nixos.org/packages"; }
            { name = "NixOS Options Search"; url = "https://search.nixos.org/options"; }
            { name = "Nixpkgs"; url = "https://github.com/NixOS/nixpkgs"; }
            {
              name = "Home Manager";
              bookmarks = [
                { name = "Configuration Options"; url = "https://nix-community.github.io/home-manager/options.xhtml"; }
                { name = "NixOS Configuration Options"; url = "https://nix-community.github.io/home-manager/nixos-options.xhtml"; }
              ];
            }
            { name = "Nix Reference Manual"; url = "https://nixos.org/manual/nix/stable"; }
            { name = "Nixpkgs Manual"; url = "https://nixos.org/manual/nixpkgs/stable"; }
          ];
        }
      ];
    };
  };
}
