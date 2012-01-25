# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit mingw32
GNOME_ORG_MODULE=${M32_PN}
inherit gnome2

DESCRIPTION="GTK+ & GNOME Accessibility Toolkit"
HOMEPAGE="http://projects.gnome.org/accessibility/"

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
	gnome2_src_prepare
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

	epatch "${FILESDIR}/${M32_PN}-2.2.0-dllmain.patch"

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
	mingw32_clean_files
}

