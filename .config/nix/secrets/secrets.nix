let
  apple = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMJPqD/bBsBSxTRbGilwEYTny1yaHaicHNmfzKe3MDE0 hetzner";

  allKeys = [ apple ];
in
{
  # Add secrets here:
  #   "secret-name.age".publicKeys = allKeys;
  #
  # Then encrypt with:
  #   cd secrets && nix run github:ryantm/agenix -- -e secret-name.age

  "openai-key.age".publicKeys = allKeys;
}
