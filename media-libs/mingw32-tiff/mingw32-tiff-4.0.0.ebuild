# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit libtool mingw32

DESCRIPTION="Library for manipulation of TIFF (Tag Image File Format) images"
HOMEPAGE="http://www.remotesensing.org/libtiff/"
SRC_URI="
	http://download.osgeo.org/libtiff/${M32_P}.tar.gz
	ftp://ftp.remotesensing.org/pub/libtiff/${M32_P}.tar.gz
"

LICENSE="as-is"
SLOT="0"

KEYWORDS="x86 amd64"
IUSE="lzma jpeg zlib jbig +cxx"

RDEPEND="
	jpeg? ( media-libs/mingw32-jpeg )
	lzma? ( app-arch/mingw32-xz-utils ) 
	zlib? ( sys-libs/mingw32-zlib )
	jbig? ( media-libs/mingw32-jbigkit )
"
DEPEND="
	${RDEPEND}
"


src_prepare() {
	elibtoolize
}

src_configure() {
	econf \
		$(use_enable zlib) \
		$(use_enable jpeg) \
		$(use_enable jbig) \
		$(use_enable lzma) \
		$(use_enable cxx) \
		--without-x \
		--disable-shared \
	|| die "econf failed"

}

src_compile() {
	emake DESTDIR="${D}" install \
	|| die "emake failed"
}


src_install() {
	default

	clean_files
}

