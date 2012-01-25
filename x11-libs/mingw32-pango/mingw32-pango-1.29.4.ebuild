# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit mingw32
GNOME_ORG_MODULE=${M32_PN}
inherit gnome2 autotools eutils toolchain-funcs


DESCRIPTION="Internationalized text layout and rendering library"
HOMEPAGE="http://www.pango.org/"

LICENSE="LGPL-2 FTL"
SLOT="0"

KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="
	dev-libs/mingw32-glib
	dev-libs/mingw32-libffi
	media-libs/mingw32-freetype
	x11-libs/mingw32-cairo
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	epatch "${FILESDIR}/${M32_PN}-1.29.4-dllmain.patch"
	epatch "${FILESDIR}/${M32_PN}-1.29.4-pkgconfig.patch"
}

src_configure() {
	econf \
		--disable-shared \
		--disable-gtk-doc \
		--without-x \
		--enable-explicit-deps \
		--with-included-modules \
		--without-dynamic-modules \
	|| die "econf failed"
}

pkg_setup() {
	tc-export CXX
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "emake install failed"
	rm -rf "${D}usr/share/gtk-doc"
	mingw32_clean_files
}


