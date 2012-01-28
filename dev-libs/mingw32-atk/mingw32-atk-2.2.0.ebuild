# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit eutils mingw32

DESCRIPTION="GTK+ & GNOME Accessibility Toolkit"
HOMEPAGE="http://projects.gnome.org/accessibility/"

SRC_URI="
	mirror://gnome/sources/${M32_PN}/${PV/%.*}/${M32_P}.tar.xz
"

LICENSE="LGPL-2"

SLOT="0"

KEYWORDS="x86 amd64"

IUSE="+static-libs"

RDEPEND="
	dev-libs/mingw32-glib:2
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	epatch "${FILESDIR}/${M32_PN}-mingw32-2.2.0-dllmain.patch"
	sed \
		-e 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' \
		-i \
			Makefile.am \
			Makefile.in \
	|| die
	sed \
		-e '/-D[A-Z_]*DISABLE_DEPRECATED/d' \
		-i \
			atk/Makefile.am \
			atk/Makefile.in \
			tests/Makefile.am \
			tests/Makefile.in \
	|| die
}

src_configure() {
	econf \
		$(use_static) \
		--disable-glibtest \
		--disable-gtk-doc \
	|| die	
}

src_install() {
	mkdir -p "${D}/usr/lib"
	emake DESTDIR="${D}" install
	clean_files	
}
