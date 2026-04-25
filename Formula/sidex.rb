class Sidex < Formula
  desc "VS Code workbench running on Tauri instead of Electron"
  homepage "https://github.com/Sidenai/sidex"
  license "MIT"

  head "https://github.com/Sidenai/sidex.git", branch: "main"

  depends_on "node" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
  end


  def install
    odie "This formula currently supports macOS only." unless OS.mac?

    ENV["NODE_OPTIONS"] = "--max-old-space-size=12288"

    # Avoid using upstream Developer ID signing identity.
    # "-" means ad-hoc signing, suitable for local build/install.
    ENV["APPLE_SIGNING_IDENTITY"] = "-"

    # Avoid accidentally using CI signing/notarization variables.
    ENV.delete("APPLE_CERTIFICATE")
    ENV.delete("APPLE_CERTIFICATE_PASSWORD")
    ENV.delete("APPLE_ID")
    ENV.delete("APPLE_PASSWORD")
    ENV.delete("APPLE_TEAM_ID")
    ENV.delete("APPLE_API_KEY")
    ENV.delete("APPLE_API_ISSUER")
    ENV.delete("APPLE_API_KEY_PATH")

    system "npm", "ci"
    system "npm", "run", "setup:full"
    system "npm", "run", "build"

    # Build only the .app bundle; Homebrew formula does not need dmg.
    system "npx", "tauri", "build", "--bundles", "app"

    app = Dir["target/release/bundle/macos/*.app", "src-tauri/target/release/bundle/macos/*.app"].first
    odie "SideX.app was not built" if app.nil?

    prefix.install app

    app_name = File.basename(app)
    macos_dir = prefix/app_name/"Contents/MacOS"
    exe = Dir[macos_dir/"*"].find { |f| File.file?(f) && File.executable?(f) }
    odie "Could not find executable in #{macos_dir}" if exe.nil?

    (bin/"sidex").write <<~EOS
      #!/bin/bash
      exec "#{opt_prefix}/#{app_name}/Contents/MacOS/#{File.basename(exe)}" "$@"
    EOS
  end


  test do
    assert_path_exists prefix/"SideX.app"
    assert_path_exists bin/"sidex"
  end
end
