class IgnitionRendering1 < Formula
  desc "Rendering library for robotics applications"
  homepage "https://bitbucket.org/ignitionrobotics/ign-rendering"
  url "http://gazebosim.org/distributions/ign-rendering/releases/ignition-rendering-1.0.0~pre6.tar.bz2"
  version "1.0.0~pre6"
  sha256 "7ee824287f600562b2da1993d6fbb684b8d3d87b878c08d5a5a101c41e3bbf5b"

  bottle do
    root_url "http://gazebosim.org/distributions/bottles-simulation"
    sha256 "30a7b0f3e29551d0cc4f43654a57414d342df9112a5dca829c2e66b409914982" => :mojave
    sha256 "8c3825a79b9c62dcdbc035a9dc8b18ec9117c27f84562c0bf9a413b315813b99" => :high_sierra
  end

  depends_on "cmake" => :build

  depends_on "freeimage"
  depends_on "ignition-cmake2"
  depends_on "ignition-common3"
  depends_on "ignition-math6"
  depends_on "ignition-plugin1"
  depends_on :macos => :high_sierra # c++17
  depends_on "ogre1.9"
  depends_on "pkg-config"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include <ignition/rendering/PixelFormat.hh>
      int main(int _argc, char** _argv)
      {
        ignition::rendering::PixelFormat pf = ignition::rendering::PF_UNKNOWN;
        return ignition::rendering::PixelUtil::IsValid(pf);
      }
    EOS
    ENV.append_path "PKG_CONFIG_PATH", "#{Formula["qt"].opt_lib}/pkgconfig"
    system "pkg-config", "ignition-rendering1"
    cflags   = `pkg-config --cflags ignition-rendering1`.split(" ")
    ldflags  = `pkg-config --libs ignition-rendering1`.split(" ")
    system ENV.cc, "test.cpp",
                   *cflags,
                   *ldflags,
                   "-lc++",
                   "-o", "test"
    system "./test"
  end
end