{ ... }: {
  age = {
    identityPaths = [
      "/home/pluresque/.ssh/id_ed25519"
    ];

    secrets = {
      # Add secrets here when agenix is configured
      # Example:
      # "my-secret" = {
      #   symlink = false;
      #   path = "/home/pluresque/.config/my-secret";
      #   file = "${secrets}/my-secret.age";
      #   mode = "600";
      #   owner = "pluresque";
      #   group = "wheel";
      # };
    };
  };
}
