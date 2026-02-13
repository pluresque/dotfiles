{ ... }: {
  age = {
    identityPaths = [
      "/Users/apple/.ssh/id_ed25519"
    ];

    secrets = {
      # Add secrets here when agenix is configured
      # Example:
      # "my-secret" = {
      #   symlink = true;
      #   path = "/Users/apple/.config/my-secret";
      #   file = "${secrets}/my-secret.age";
      #   mode = "600";
      #   owner = "apple";
      #   group = "staff";
      # };
    };
  };
}
