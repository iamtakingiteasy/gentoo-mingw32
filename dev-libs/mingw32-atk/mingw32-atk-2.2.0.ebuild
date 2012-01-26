# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit eutils mingw32

DESCRIPTION="GTK+ & GNOME Accessibility Toolkit"
HOMEPAGE="http://projects.gnome.org/accessibility/"

SRC_URI="mirror://gnome/sources/atk/${PV/%.*}/${M32_P}.tar.xz"

LICENSE="LGPL-2"
SLOT="0"

KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="
	dev-libs/mingw32-glib
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	epatch "${FILESDIR}/${M32_PN}-2.2.0-dllmain.patch"
	sed 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' \
		-i Makefile.am Makefile.in \
	|| die "sed failed"
	sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' \
		-i \
			atk/Makefile.am \
			atk/Makefile.in \
			tests/Makefile.am \
			tests/Makefile.in \
	|| die "sed 2 failed"


	elibtoolize
}

src_configure() {
	econf \
		--disable-glibtest \
		--disable-shared \
		--disable-gtk-doc \
	|| die "econf failed"

}

src_install() {
	mkdir -p "${D}/usr/lib"
	emake DESTDIR="${D}" install || die "install failed"
	rm -rf "${D}usr/share/gtk-doc"
	clean_files
}

