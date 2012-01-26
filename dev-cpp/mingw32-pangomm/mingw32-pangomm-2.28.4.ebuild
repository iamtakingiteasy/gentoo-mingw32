# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit eutils mingw32

DESCRIPTION="C++ interface for pango"
HOMEPAGE="http://www.gtkmm.org"
SRC_URI="http://ftp.gnome.org/pub/gnome/sources/${M32_PN}/${PV%.*}/${M32_P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="1.4"

KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="
	x11-libs/mingw32-pango
	dev-cpp/mingw32-glibmm:2
	dev-cpp/mingw32-cairomm
	dev-libs/mingw32-libsigc++:2
"
DEPEND="
	${RDEPEND}
"

src_configure() {
	econf \
		--disable-shared \
	|| die "econf failed"

}


src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	clean_files
}

