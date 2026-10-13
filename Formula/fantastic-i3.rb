class FantasticI3 < Formula
  desc "Tiling desktop for macOS in the style of i3: yabai, skhd and SketchyBar"
  homepage "https://github.com/mejistus/fantastic-i3-app"
  url "https://github.com/mejistus/fantastic-i3-app.git",
      tag:      "v0.1.0",
      revision: "ca7f93f0836c9322d51f1cfd42e0de7122109f1d"
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
      第一次装好后运行（接好配置、启动服务、检查权限）：
        fantastic-i3 setup
      以后 brew upgrade fantastic-i3 之后：
        fantastic-i3 restart
    EOS
  end

  test do
    assert_match "fantastic-i3 setup", shell_output("#{bin}/fantastic-i3 2>&1", 1)
    assert_match "⌃S 服务模式", shell_output("#{bin}/fantastic-i3 keys")
  end
end
