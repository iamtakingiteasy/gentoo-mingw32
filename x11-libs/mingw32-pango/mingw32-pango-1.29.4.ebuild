# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit autotools eutils libtool mingw32

DESCRIPTION="Internationalized text layout and rendering library"
HOMEPAGE="http://www.pango.org/"

SRC_URI="
	mirror://gnome/sources/${M32_PN}/${PV/%.*}/${M32_P}.tar.xz
"

LICENSE="LPGL-2 FTL"

SLOT="0"

KEYWORDS="x86 amd64"

IUSE="+static-libs"

RDEPEND="
	dev-libs/mingw32-glib:2
	dev-libs/mingw32-libffi
	x11-libs/mingw32-cairo
	media-libs/mingw32-freetype:2
	media-libs/mingw32-fontconfig:1.0
"
DEPEND="
"

src_prepare() {
	epatch "${FILESDIR}/${M32_PN}-mingw32-1.29.4-configure-static.patch"
	epatch "${FILESDIR}/${M32_PN}-mingw32-1.29.4-dllmain.patch"
	sed -e '/^Requires:/s/$/ gthread-2.0/' -i pangocairo.pc.in || die
	sed -e '/^Libs:/s/$/ -lusp10/' -i pangowin32.pc.in || die
	tc-export CXX
	eautoreconf
}

src_configure() {
	econf \
		$(use_static) \
		--disable-gtk-doc \
		--without-x \
		--enable-explicit-deps \
		--with-included-modules \
		--without-dynamic-modules \
	|| die
}

src_install() {
	 emake DESTDIR="${D}" install || die
	clean_files	
}
