class FantasticI3 < Formula
  desc "Tiling desktop for macOS in the style of i3: yabai, skhd and SketchyBar"
  homepage "https://github.com/mejistus/fantastic-i3-app"
  url "https://github.com/mejistus/fantastic-i3-app.git",
      tag:      "v0.1.9",
      revision: "2764e2d86377ab48dacbf1aa90286613dc2d8683"
  license "GPL-3.0-or-later"
  head "https://github.com/mejistus/fantastic-i3-app.git", branch: "main"

  depends_on arch: :arm64
  depends_on "asmvik/formulae/skhd"
  depends_on "asmvik/formulae/yabai"
  depends_on "felixkratz/formulae/sketchybar"
  depends_on "jq"
  depends_on :macos

  def install
    libexec.install "bin", "yabai", "skhd", "sketchybar"
    # skhdrc 末尾 .load 的文件：yabai 启动时按脚本扩展有没有加载换成 sa 或 native
    ln_s "workspaces-native.skhdrc", libexec/"skhd/workspaces.skhdrc"
    bin.install_symlink libexec.glob("bin/*")
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        fantastic-i3 setup

      Setup links the configuration into ~/.config, starts yabai, skhd and
      SketchyBar, and checks the required permissions. It is safe to run again.

      Do not copy SketchyBar's example configuration into ~/.config/sketchybar,
      as its own caveat suggests: that directory points to the fantastic-i3
      configuration, and the example would overwrite it.

      After upgrading fantastic-i3, restart the services:
        fantastic-i3 restart

      Instant workspace switching requires yabai's scripting addition, which
      needs System Integrity Protection partially disabled:
        fantastic-i3 setup-sa

      Before uninstalling, remove the links and services that setup created:
        fantastic-i3 uninstall
    EOS
  end

  test do
    ENV["FANTASTIC_I3_LANG"] = "en"
    assert_equal "fantastic-i3 #{version}", shell_output("#{bin}/fantastic-i3 --version").strip
    assert_match "Usage: fantastic-i3 <command>", shell_output("#{bin}/fantastic-i3 --help")
    assert_match "Reload the configuration", shell_output("#{bin}/fantastic-i3 keys")
  end
end
