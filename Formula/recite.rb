class Recite < Formula
  desc "Copy a command and its output as a pasteable console block"
  homepage "https://github.com/ken0nek/recite"
  url "https://github.com/ken0nek/recite/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "a5c78874817d1547685b3417b61569d50fd50fe4de1a4655799fbbf778406274"
  license "MIT"
  head "https://github.com/ken0nek/recite.git", branch: "main"

  def install
    bin.install "functions/recite", "functions/recite-core", "functions/recite-clip"
    fish_function.install Dir["functions/*.fish"]
  end

  def caveats
    <<~EOS
      recite installs no keybinding, by design. To bind alt-enter:

          fish  bind alt-enter __recite_submit

          zsh   eval "$(recite init zsh)"
                bindkey '^[^M' __recite_submit

      The `cmd 2>&1 | recite` form needs no binding in either shell.

      If alt-enter does nothing, macOS terminals break it in two unrelated
      ways. Terminal.app composes Option into a character, so the shell sees a
      bare enter: tick Settings > Profiles > Keyboard > "Use Option as Meta
      Key". WezTerm sends the modifier correctly but keeps the keystroke for
      Toggle Full Screen; release it in wezterm.lua:

          config.keys = {
            { key = 'Enter', mods = 'ALT',
              action = wezterm.action.DisableDefaultAssignment },
          }

      Ghostty and iTerm2 need no setting.
    EOS
  end

  test do
    core = bin/"recite-core"
    assert_equal "```console\n$ echo hi\nhi\n```\n",
      pipe_output("#{core} --as 'echo hi'", "hi\n")
    assert_match "[REDACTED]", pipe_output(core.to_s, "key=sk-abc123\n")
    assert_match(/recite-core\s+0\.2\.0/, shell_output("#{bin}/recite --version"))
  end
end
