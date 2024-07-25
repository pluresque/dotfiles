{ pkgs, ... }: {

  ##########################################################################
  # 
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  ##########################################################################
  
  programs.zsh.enable = true;
  
  environment.systemPackages = with pkgs; [
    # Install packages from nix's official package repository.
    # archives
  ];
  environment.variables.EDITOR = "nvim";

  services.skhd = {
      enable = true;
      package = pkgs.skhd;
      skhdConfig = ''
    # Focus window  
      '';
  };

  # services.postgresql = {
  #   enable = true;
  #   ensureDatabases = [ "database" ];
  #   authentication = pkgs.lib.mkOverride 10 ''
  #     #type database  DBuser  auth-method
  #     local all       all     trust
  #   '';
  #   initialScript = pkgs.writeText "backend-initScript" ''
  #     CREATE ROLE user WITH LOGIN PASSWORD 'password' CREATEDB;
  #     CREATE DATABASE nixcloud;
  #     GRANT ALL PRIVILEGES ON DATABASE databese TO user;
  #   '';
  # };

}
