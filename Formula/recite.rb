class Recite < Formula
  desc "Copy a command and its output as a pasteable console block"
  homepage "https://github.com/ken0nek/recite"
  url "https://github.com/ken0nek/recite/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "2f5a91e6542a7593ffb04171ddeed1a0a316381d2d364c080d9b7c374084f25c"
  license "MIT"
  head "https://github.com/ken0nek/recite.git", branch: "main"

  depends_on "fish"

  def install
    bin.install "functions/recite-core", "functions/recite-clip"
    fish_function.install Dir["functions/*.fish"]
  end

  def caveats
    <<~EOS
      recite installs no keybinding, by design. To bind alt-enter, add to
      ~/.config/fish/config.fish:

          bind alt-enter __recite_submit

      On macOS the Option key must arrive as Alt: Ghostty needs
      `macos-option-as-alt`; Terminal.app "Use Option as Meta Key"; iTerm2
      per-profile. The `cmd 2>&1 | recite` form needs no binding.
    EOS
  end

  test do
    core = bin/"recite-core"
    assert_equal "```console\n$ echo hi\nhi\n```\n",
      pipe_output("#{core} --as 'echo hi'", "hi\n")
    assert_match "[REDACTED]", pipe_output(core.to_s, "key=sk-abc123\n")
  end
end
