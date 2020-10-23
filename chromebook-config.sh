# chromebook-config.sh - Configuration file for chromebook-setup

# stuff required for snow/peach for now
#  from google: nv_uboot-snow-simplefb.kpart
#
# set NVUBOOT=1 to enable  (not wired yet))

# default rootfs and toolchain (arm)
TOOLCHAIN="gcc-arm-8.2-2018.08-x86_64-arm-linux-gnueabihf"
TOOLCHAIN_URL="https://developer.arm.com/-/media/Files/downloads/gnu-a/8.2-2018.08/$TOOLCHAIN.tar.xz"
# arm64 rootfs and toolchain
ARM64_TOOLCHAIN="gcc-arm-8.2-2018.08-x86_64-aarch64-linux-gnu"
ARM64_TOOLCHAIN_URL="https://developer.arm.com/-/media/Files/downloads/gnu-a/8.2-2018.08/$ARM64_TOOLCHAIN.tar.xz"

# debian rootfs images
DEBIAN_SUITE="sid"
ROOTFS_BASE_URL="https://people.collabora.com/~eballetbo/debian/images/"

# here we default to the stage4 musl hardened if available, and fall
# back to stage3. Only recent builds are chosen, either musl or the
# standard glibc (mainly only the armv7 glibc stage is old).
if [[ -n $USE_BLEEDING ]]; then
    GENTOO_MIRROR="https://files.emjay-embedded.co.uk/"
else
    GENTOO_MIRROR="https://gentoo.osuosl.org/"
fi

if [[ -n $DO_GENTOO ]]; then
    if [[ $USE_LIBC == "glibc" ]]; then
        GENTOO_AMD64_BASE="releases/amd64/autobuilds/current-stage4-amd64-minimal/hardened/"
        AMD64_STAGE="stage4-amd64-hardened+minimal-20190821T214502Z.tar.xz"
        GENTOO_ARM64_BASE="releases/arm64/autobuilds/current-stage3-arm64/"
        ARM64_STAGE="stage3-arm64-20200815T210543Z.tar.xz"
        if [[ -n $USE_BLEEDING ]]; then
            GENTOO_ARM_BASE="unofficial-gentoo/arm-stages/testing/armv7a/glibc/"
            ARM_STAGE="stage3-armv7a-20191010-113500UTC.tar.bz2"
        else
            GENTOO_ARM_BASE="releases/arm/autobuilds/current-stage3-armv7a_hardfp/"
            #ARM_STAGE="stage3-armv7a_hardfp-20200509T210605Z.tar.xz"
            ARM_STAGE="stage4-armv7a-hardfp-20201015.tar.bz2"
        fi
    elif [[ $USE_LIBC == "musl" ]]; then
        GENTOO_AMD64_BASE="experimental/amd64/musl/"
        AMD64_STAGE="stage4-amd64-musl-hardened-20180721.tar.bz2"
        GENTOO_ARM64_BASE="experimental/arm64/musl/"
        ARM64_STAGE="stage3-arm64-musl-hardened-20190908.tar.bz2"
        if [[ -n $USE_BLEEDING ]]; then
            GENTOO_ARM_BASE="unofficial-gentoo/arm-stages/testing/armv7a/musl/"
            ARM_STAGE="stage3-armv7a_hardfp-musl-hardened-20191011-132742UTC.tar.bz2"
        else
            GENTOO_ARM_BASE="experimental/arm/musl/"
            ARM_STAGE="stage3-armv7a_hardfp-musl-hardened-20190429.tar.bz2"
        fi
    else
        echo "No libc was defined!! Set USE_LIBC to one of: musl or glibc!!"
        exit 1
    fi
fi

# alternate minimal rootfs for debian and ubuntu on arm
# note these are console only but they do have wifi tools
# for now, browse the ALT_BASE_URL to look for updates
ALT_BASE_URL="https://rcn-ee.com/rootfs/eewiki/minfs/"
STRETCH_BASE="debian-9.11-minimal-armhf-2019-11-23"
BUSTER_BASE="debian-10.2-minimal-armhf-2019-11-23"
BIONIC_BASE="ubuntu-18.04.3-minimal-armhf-2020-02-10"
XENIAL_BASE="ubuntu-16.04.4-minimal-armhf-2018-03-26"
FOCAL_BASE="ubuntu-20.04.1-minimal-armhf-2020-08-24"

STRETCH_TARBALL="${STRETCH_BASE}.tar.xz"
BUSTER_TARBALL="${BUSTER_BASE}.tar.xz"
BIONIC_TARBALL="${BIONIC_BASE}.tar.xz"
XENIAL_TARBALL="${XENIAL_BASE}.tar.xz"
FOCAL_TARBALL="${FOCAL_BASE}.tar.xz"

TOUCH_ARM_URL="https://ci.ubports.com/job/xenial-mainline-edge-rootfs-armhf/"
TOUCH_ARM64_URL="https://ci.ubports.com/job/xenial-mainline-edge-rootfs-arm64/"
TOUCH_BASE="lastSuccessfulBuild/artifact/out/"
TOUCH_ARM_TARBALL="ubuntu-touch-xenial-edge-armhf-rootfs.tar.gz"
#TOUCH_ARM_TARBALL="ubuntu-touch-xenial-edge-armhf-rootfs-cfgd.tar.bz2"
TOUCH_ARM64_TARBALL="ubuntu-touch-xenial-edge-arm64-rootfs.tar.gz"

if [[ -n $USE_KALI ]]; then
    KRNL_SRC_DIR="linux-kali"
else
    KRNL_SRC_DIR="linux-stable"
fi

KERNEL_URL="git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KALI_KERNEL_URL="https://gitlab.com/kalilinux/packages/linux.git"

if [[ -n $DO_STRETCH || -n $DO_BUSTER || -n $DO_BIONIC || -n $DO_XENIAL || -n $DO_FOCAL ]]; then
    if [[ -n $DO_STRETCH ]]; then
        ROOTFS="debian-stretch"
        BASE_DIR="${STRETCH_BASE}"
    elif [[ -n $DO_BUSTER ]]; then
        ROOTFS="debian-buster"
        BASE_DIR="${BUSTER_BASE}"
    elif [[ -n $DO_BIONIC ]]; then
        ROOTFS="ubuntu-bionic"
        BASE_DIR="${BIONIC_BASE}"
    elif [[ -n $DO_XENIAL ]]; then
        ROOTFS="ubuntu-xenial"
        BASE_DIR="${XENIAL_BASE}"
    elif [[ -n $DO_FOCAL ]]; then
        ROOTFS="ubuntu-focal"
        BASE_DIR="${FOCAL_BASE}"
    fi
    ROOTFS_BASE_URL="${ALT_BASE_URL}"
fi

# Current Working Directory
CWD=$PWD

# Chromebook-specific config.

declare -A chromebook_names=(
    ["XE303C12"]="Samsung Chromebook"
    ["C100PA"]="ASUS Chromebook Flip C100PA"
    ["NBCJ2"]="CTL J2 Chromebook for Education"
    ["CB5-311"]="Acer Chromebook 13"
    ["C810-T78Y"]="Acer Chromebook 13 4GB"
    ["XE513C24"]="Samsung Chromebook Plus"
)
