{ ... }: {
  age = {
    identityPaths = [
      "/home/pluresque/.ssh/id_ed25519"
    ];

    secrets = {
      # Example:
      # "my-secret" = {
      #   symlink = false;
      #   file = ../../secrets/my-secret.age;
      #   path = "/home/pluresque/.config/my-secret";
      #   mode = "600";
      #   owner = "pluresque";
      #   group = "wheel";
      # };
    };
  };
}
