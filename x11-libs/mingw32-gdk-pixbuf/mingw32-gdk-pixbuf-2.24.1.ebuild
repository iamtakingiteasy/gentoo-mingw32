# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit autotools eutils libtool mingw32

DESCRIPTION="Image loading library for GTK+"
HOMEPAGE="http://www.gtk.org/"

SRC_URI="
	mirror://gnome/sources/${M32_PN}/${PV%.*}/${M32_P}.tar.xz
"

LICENSE="LGPL-2"

SLOT="2"

KEYWORDS="x86 amd64"

IUSE="+static-libs +jpeg +tiff"

RDEPEND="
	dev-libs/mingw32-glib:2
	media-libs/mingw32-libpng:0
	sys-devel/mingw32-gettext
	jpeg? ( media-libs/mingw32-jpeg )
	tiff? ( media-libs/mingw32-tiff:0 )
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	epatch "${FILESDIR}/${M32_PN}-mingw32-2.24.1-io-gdip-anim.patch"
	epatch "${FILESDIR}/${M32_PN}-mingw32-2.24.1-dllmain.patch"
	epatch "${FILESDIR}/${M32_PN}-mingw32-2.24.1-configure-static.patch"
	sed -i -e 's:libpng15:libpng libpng15:' configure.ac || die
	sed \
		-e '/^Libs:/{s/$/ -lgdiplus -lz/}' \
		-e '/^Requires:/{s/$/ gio-2.0 gthread-2.0 libpng/}' \
		-i \
			gdk-pixbuf-2.0.pc.in \
	|| die
	eautoreconf
}

src_configure() {
	econf \
		$(use_static) \
		$(use_with jpeg libjpeg) \
		$(use_with tiff libtiff) \
		--with-included-loaders=yes \
		--disable-modiles \
	|| die
}


src_install() {
	emake -j1 DESTDIR="${D}" install || die
	clean_files	
}
