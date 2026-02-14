{
  lib,
  useremail,
  ...
}:
{
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f ~/.gitconfig ~/.config/git/ignore
  '';

  programs.git = {
    enable = true;
    lfs.enable = true;

    ignores = [
      ".DS_Store"
      "thumbs.db"
      "CLAUDE.md"
      "GEMINI.md"
      ".claude"
    ];

    settings = {
      user = {
        name = "pluresque";
        email = useremail;
        signingkey = "~/.ssh/id_rsa.pub";
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      commit.gpgsign = true;
      gpg.format = "ssh";
      alias = {
        ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
        ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
        amend = "commit --amend -m";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      features = "side-by-side";
    };
  };
}
