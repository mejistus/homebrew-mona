class ZhihuCli < Formula
  include Language::Python::Virtualenv

  desc "Zhihu command-line tool — search, browse hot list, ask, post pins/articles"
  homepage "https://github.com/BAIGUANGMEI/zhihu-cli"
  url "https://files.pythonhosted.org/packages/f6/ab/def48157a03de157fa733d87a30efdf6de0fec6e29e12920a46a57e2915a/pyzhihu_cli-0.2.4.tar.gz"
  sha256 "e73d21875567bea9c0ab79efbc6d26ed4c51c92e0860bb7e1ac934d3f390b8f9"
  license "Apache-2.0"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version, shell_output("#{bin}/zhihu --version")
    assert_match "Usage:", shell_output("#{bin}/zhihu --help")
  end
end