# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit autotools eutils libtool mingw32

DESCRIPTION="A vector graphics library with cross-device output support"
HOMEPAGE="http://cairographics.org/"

SRC_URI="
	http://cairographics.org/releases/${M32_P}.tar.gz
"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"

SLOT="0"

KEYWORDS="x86 amd64"

IUSE="+static-libs +glib +svg"

RDEPEND="
	media-libs/mingw32-fontconfig
	media-libs/mingw32-freetype:2
	media-libs/mingw32-libpng:0
	sys-libs/mingw32-zlib
	x11-libs/mingw32-pixman
	glib? ( dev-libs/mingw32-glib:2 )
	svg? ( dev-libs/mingw32-libxml2 )
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	epatch "${FILESDIR}/${M32_PN}-orig-1.10.2-interix-1.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-1.10.2-buggy_gradients.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-1.10.2-interix-2.patch"
	epatch "${FILESDIR}/${M32_PN}-mingw32-1.10.2-ffs.patch"
	epatch "${FILESDIR}/${M32_PN}-mingw32-1.10.2-define.patch"
	epatch "${FILESDIR}/${M32_PN}-mingw32-1.10.2-dllmain.patch"
	
	sed \
		-e '/^Libs:/{s/$/ -lgdi32 -lmsimg32/}' \
		-e '/^Libs:/iRequires: gobject-2.0 glib-2.0 pixman-1 freetype2 libpng fontconfig' \
		-i \
			src/cairo.pc.in \
	|| die

	eautoreconf
}

src_configure() {
	econf \
		$(use_static) \
		$(use_enable glib gobject) \
		$(use_enable svg) \
		--disable-xlib \
		--disable-xlib-xrender \
		--disable-os2 \
		--disable-beos \
		--disable-directfb \
		--disable-xlib-xcb4 \
		--disable-pthread \
		--disable-gtk-doc \
		--enable-win32-font \
		--enable-win32 \
		--enable-ft \
		--enable-fc \
		--enable-pdf \
		--enable-png \
		--enable-ps \
	|| die
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die
	clean_files	
}
