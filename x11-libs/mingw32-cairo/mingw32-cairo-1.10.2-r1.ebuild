# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit eutils flag-o-matic autotools mingw32


DESCRIPTION="A vector graphics library with cross-device output support"
HOMEPAGE="http://cairographics.org/"
SRC_URI="http://cairographics.org/releases/${M32_P}.tar.gz"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"

KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="
	media-libs/mingw32-freetype
	media-libs/mingw32-libpng
	media-libs/mingw32-fontconfig
	sys-libs/mingw32-zlib
	x11-libs/mingw32-pixman
	dev-libs/mingw32-glib
	dev-libs/mingw32-libxml2

"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	epatch "${FILESDIR}/${M32_PN}-1.8.8-interix.patch"
	epatch "${FILESDIR}/${M32_PN}-1.10.0-buggy_gradients.patch"
	epatch "${FILESDIR}/${M32_P}-interix.patch"
	epatch "${FILESDIR}/${M32_P}-ffs.patch"
	epatch "${FILESDIR}/${M32_P}-mingw32.patch"
	epatch "${FILESDIR}/${M32_P}-dllmain.patch"
	epatch "${FILESDIR}/${M32_P}-pkgconfig.patch"
	
	eautoreconf
}

src_configure() {
	append-flags -finline-limit=1200
	
	econf \
		--disable-shared \
		--disable-gtk-doc \
		--disable-test-surfaces \
		--disable-gcov \
		--disable-xlib \
		--disable-xlib-xrender \
		--disable-xcb \
		--disable-quartz \
		--disable-quartz-font \
		--disable-quartz-image \
		--disable-os2 \
		--disable-beos \
		--disable-glitz \
		--disable-directfb \
		--disable-atomic \
		--enable-win32 \
		--enable-win32-font \
		--enable-png \
		--enable-ft \
		--enable-fc \
		--enable-ps \
		--enable-pdf \
		--enable-svg \
		--disable-pthread \
	|| die "econf failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "emake install failed"
	rm -rf "${D}usr/share/gtk-doc"
	clean_files
}


