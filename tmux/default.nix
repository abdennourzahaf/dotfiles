{pkgs, ...}: let
  tmux-sessions-fzf = pkgs.writeShellScriptBin "s" (builtins.readFile ../scripts/tmux-sessions-fzf.sh);
  tmux-output-nvim = pkgs.writeShellScriptBin "tmux-output-nvim" (builtins.readFile ../scripts/tmux-output-nvim.sh);
in {
  programs.tmux.enable = true;

  users.users.abdennour.packages = [
    tmux-sessions-fzf
    tmux-output-nvim
  ];
}
