# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit autotools libtool mingw32


DESCRIPTION="Image loading library for GTK+"
HOMEPAGE="http://www.gtk.org/"

SRC_URI="mirror://gnome/sources/gdk-pixbuf/${PV%.*}/${M32_P}.tar.xz"

LICENSE="LGPL-2"
SLOT="2"

KEYWORDS="x86 amd64"
IUSE="+jpeg +tiff"

RDEPEND="
	dev-libs/mingw32-glib
	media-libs/mingw32-libpng
	jpeg? ( media-libs/mingw32-jpeg )
	tiff? ( media-libs/mingw32-tiff )
	sys-devel/mingw32-gettext
"
DEPEND="
	${RDEPEND}
"
:
src_prepare() {
	epatch "${FILESDIR}/${M32_PN}-2.24.1-io-gdip-anim-fix.patch"
	epatch "${FILESDIR}/${M32_PN}-2.24.1-pkgconfig.patch"
	epatch "${FILESDIR}/${M32_PN}-2.25.0-dllmain.patch"
	sed -i -e 's:libpng15:libpng libpng15:' configure.ac || die
	sed \
		-e '/^Libs:/{s/$/ -lgdiplus -lz/}' \
		-e '/^Requires:/{s/$/ libpng/}' \
		-i \
			gdk-pixbuf-2.0.pc.in \
	|| die
	
	elibtoolize
	eautoreconf
}

src_configure() {
	econf \
		$(use_with jpeg libjpeg) \
		$(use_with tiff libtiff) \
		--disable-shared \
		--with-included-loaders=yes \
		--disable-modiles \
	|| die "econf failed"

}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "emake install failed"
	rm -rf "${D}usr/share/gtk-doc"
	clean_files
}

