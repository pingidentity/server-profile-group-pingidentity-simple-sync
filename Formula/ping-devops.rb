class PingDevops < Formula
  desc "PingIdentity DevOps Command-Line Tool"
  homepage "https://devops.pingidentity.com"
  url "https://github.com/pingidentity/ping-devops/archive/v0.5.5.tar.gz"
  sha256 "45f13d69fa43eb905956100de77a996ee48c2e868c7cb49130e5dc4e4efb13de"

  depends_on "kubernetes-cli"
  depends_on "kubectx"
  depends_on "kustomize"
  depends_on "gettext"
  depends_on "stern"
  depends_on "jq"

  def install
    bin.install "ping-devops"
    etc.install "etc/bash_profile.ping-devops"

  end

  # move previous version of etc/bash_profile.ping-devops
  def move_profile
    old_profile = etc/"bash_profile.ping-devops"
    new_profile = etc/"bash_profile.ping-devops.default"
    # Else, we're already using the latest version:
    return unless new_profile.exist?

    backup = etc/"bash_profile.ping-devops.old"
    opoo "Existing bash_profile.ping-devops will be moved to #{backup}."
    mv old_profile, backup
    mv new_profile, old_profile
  end

  def post_install
    move_profile
    ohai "Verify your existing Ping Identity DevOps configs with"
    ohai "  ping-devops info"
    ohai "  ping-devops config"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/ping-devops -h 2>&1")
  end
end
