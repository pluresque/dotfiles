{ ... }: {
  age = {
    identityPaths = [
      "/Users/apple/.ssh/id_ed25519"
    ];

    secrets = {
      "openai-key" = {
        file = ../../secrets/openai-key.age;
        path = "/Users/apple/.config/openai-key";
        mode = "600";
        owner = "apple";
        group = "staff";
      };
    };
  };
}
