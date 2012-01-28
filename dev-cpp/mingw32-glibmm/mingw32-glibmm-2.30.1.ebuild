# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit eutils mingw32

DESCRIPTION="C++ interface for glib2"
HOMEPAGE="http://www.gtkmm.org"

SRC_URI="
	http://ftp.gnome.org/pub/gnome/sources/${M32_PN}/${PV%.*}/${M32_P}.tar.xz
"

LICENSE="|| ( LGPL-2.1 GPL-2 )"

SLOT="2"

KEYWORDS="x86 amd64"

IUSE="+static-libs"

RDEPEND="
	dev-libs/mingw32-libsigc++:2
	dev-libs/mingw32-glib:2
"
DEPEND="
"

src_prepare() {
	sed 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' \
		-i Makefile.am Makefile.in || die "sed 1 failed"

	sed 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' \
		-i Makefile.am Makefile.in || die "sed 2 failed"
}

src_configure() {
	econf \
		$(use_static) \
		--disable-schemas-compile \
		--enable-deprecated-api \
	|| die
}

src_install() {
	emake DESTDIR="${D}" install || die
	rm -r "${ED}usr/share/doc/glibmm*"
	clean_files	
}
