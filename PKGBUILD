# Maintainer: Jesus Alvarez <jeezusjr at gmail dot com>
#
# This PKGBUILD was generated by the archzfs build scripts located at
#
# http://github.com/archzfs/archzfs
#
# ! WARNING !
#
# The archzfs packages are kernel modules, so these PKGBUILDS will only work with the kernel package they target. In this
# case, the archzfs-linux-lts packages will only work with the default linux-lts package! To have a single PKGBUILD target
# many kernels would make for a cluttered PKGBUILD!
#
# If you have a custom kernel, you will need to change things in the PKGBUILDS. If you would like to have AUR or archzfs repo
# packages for your favorite kernel package built using the archzfs build tools, submit a request in the Issue tracker on the
# archzfs github page.
#
#
pkgname="zfs-linux-lts"
pkgver=0.6.5.8_4.4.26_1
pkgrel=2
pkgdesc="Kernel modules for the Zettabyte File System."
depends=("kmod" "spl-linux-lts" "zfs-utils-linux-lts" "linux-lts=4.4.26")
makedepends=("linux-lts-headers=4.4.26")
arch=("x86_64")
url="http://zfsonlinux.org/"
source=("https://github.com/zfsonlinux/zfs/releases/download/zfs-0.6.5.8/zfs-0.6.5.8.tar.gz")
sha256sums=("d77f43f7dc38381773e2c34531954c52f3de80361b7bb10c933a7482f89cfe84")
groups=("archzfs-linux-lts")
license=("CDDL")
install=zfs.install
provides=("zfs")
conflicts=('zfs-linux' 'zfs-linux-git')

build() {
    cd "${srcdir}/zfs-0.6.5.8"
    ./autogen.sh
    ./configure --prefix=/usr --sysconfdir=/etc --sbindir=/usr/bin --libdir=/usr/lib \
                --datadir=/usr/share --includedir=/usr/include --with-udevdir=/lib/udev \
                --libexecdir=/usr/lib/zfs-0.6.5.8 --with-config=kernel \
                --with-linux=/usr/lib/modules/4.4.26-1-lts/build \
                --with-linux-obj=/usr/lib/modules/4.4.26-1-lts/build
    make
}

package() {
    cd "${srcdir}/zfs-0.6.5.8"
    make DESTDIR="${pkgdir}" install
    cp -r "${pkgdir}"/{lib,usr}
    rm -r "${pkgdir}"/lib
    # Remove reference to ${srcdir}
    sed -i "s+${srcdir}++" ${pkgdir}/usr/src/zfs-*/4.4.26-1-lts/Module.symvers
}
