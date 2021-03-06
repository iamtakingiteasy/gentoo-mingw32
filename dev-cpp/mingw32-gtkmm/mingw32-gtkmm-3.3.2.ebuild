# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit eutils mingw32

DESCRIPTION="C++ interface for GTK+2"
HOMEPAGE="http://www.gtkmm.org"

SRC_URI="
	http://ftp.gnome.org/pub/gnome/sources/${M32_PN}/${PV%.*}/${M32_P}.tar.xz
"

LICENSE="LGPL-2.1"

SLOT="3.0"

KEYWORDS="x86 amd64"

IUSE="+static-libs"

RDEPEND="
	dev-cpp/mingw32-glibmm:2
	x11-libs/mingw32-gtk+:3
	dev-cpp/mingw32-atkmm
	dev-cpp/mingw32-cairomm
	dev-cpp/mingw32-pangomm:1.4
	dev-libs/mingw32-libsigc++:2

"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	sed 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
	|| die "sed 1 failed"
	sed 's/^\(SUBDIRS =.*\)demos\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
	|| die "sed 2 failed"

}

src_configure() {
	econf \
		$(use_static) \
		--enable-api-atkmm \
		--disable-maintainer-mode \
	|| die
}

src_install() {
	emake DESTDIR="${D}" install || die
	clean_files	
}
