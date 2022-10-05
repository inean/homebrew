class MacTelnet < Formula
  desc "Console tools for connecting to, and serving, devices using MikroTik RouterOS MAC-Telnet protocol"
  homepage "http://lunatic.no/2010/10/routeros-mac-telnet-application-for-linux-users/"
  license "GPL-2.0-or-only"
  revision 1

  head do
    url  "https://github.com/haakonnessjoen/MAC-Telnet.git"
    
    depends_on "autoconf"   => :build
    depends_on "automake"   => :build
    depends_on "libtool"    => :build
    depends_on "gettext"    => :build
  end
  
  depends_on "pkg-config"   => :build
  depends_on "openssl"


  def install
    std_configure_args << "--disable-silent-rules"
    std_configure_args << "--prefix=#{prefix}"
    std_configure_args << "--sysconfdir=#{etc}/mactelnetd"
    std_configure_args << "--with-openssl=#{Formula["openssl"].opt_prefix}"
    
    system "./autogen.sh" if build.head?
    inreplace "config/Makefile.in", /root/, "$$(whoami)"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "MAC-Telnet 1.0.0\n", 
      shell_output("#{bin}/mactelnet -v")
    assert_equal "MAC-Telnet Daemon 1.0.0\n", 
      shell_output("#{bin}/mactelnetd -v")
  end
end
