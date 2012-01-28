# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit eutils mingw32

DESCRIPTION="C++ interface for the ATK library"
HOMEPAGE="http://www.gtkmm.org"

SRC_URI="
	http://ftp.gnome.org/pub/gnome/sources/${M32_PN}/${PV%.*}/${M32_P}.tar.xz
"

LICENSE="LGPL-2.1"

SLOT="0"

KEYWORDS="x86 amd64"

IUSE="+static-libs"

RDEPEND="
	dev-cpp/mingw32-glibmm:2
	dev-libs/mingw32-libsigc++:2
	dev-libs/mingw32-atk
"
DEPEND="
	${RDEPEND}
"

src_configure() {
	econf \
		$(use_static) \
	|| die
}

src_install() {
	emake DESTDIR="${D}" install || die
	clean_files	
}
