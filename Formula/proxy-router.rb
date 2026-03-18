class ProxyRouter < Formula
  desc "Local proxy that routes connections to an upstream or direct based on configurable rules"
  homepage "https://github.com/wstucco/proxy-router"
  version "0.1.0" # updated by CI

  on_arm do
    url "https://github.com/wstucco/proxy-router/releases/download/v#{version}/proxy-router-v#{version}-darwin-arm64"
    sha256 "c6675741bb797c200ab7472288b523983075d463b80040212937aa39cc68f025" # updated by CI
  end

  def install
    bin.install "proxy-router-v#{version}-darwin-arm64" => "proxy-router"
  end

  service do
    run [opt_bin/"proxy-router", "run", "-config", etc/"proxy-router/config.json"]
    keep_alive true
    log_path var/"log/proxy-router.log"
    error_log_path var/"log/proxy-router.err"
  end

  def post_install
    (etc/"proxy-router").mkpath
    unless (etc/"proxy-router/config.json").exist?
      system bin/"proxy-router", "-gen-config" do |io|
        (etc/"proxy-router/config.json").write io.read
      end
    end
  end

  def caveats
    <<~EOS
      Run the following to install shell completions and finish setup:
        proxy-router install

      To start proxy-router as a service:
        brew services start proxy-router

      Config file: #{etc}/proxy-router/config.json
      Logs:        #{var}/log/proxy-router.{log,err}
    EOS
  end

  test do
    system bin/"proxy-router", "version"
  end
end
