# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit eutils libtool mingw32


DESCRIPTION="Library for manipulation of TIFF (Tag Image File Format) images"
HOMEPAGE="http://www.remotesensing.org/libtiff/"

SRC_URI="
	http://download.osgeo.org/libtiff/${M32_P}.tar.gz
	ftp://ftp.remotesensing.org/pub/libtiff/${M32_P}.tar.gz
"

LICENSE="as-is"

SLOT="0"

KEYWORDS="x86 amd64"

IUSE="+static-libs +jpeg +zlib +cxx"

RDEPEND="
	jpeg? ( media-libs/mingw32-jpeg )
	zlib? ( sys-libs/mingw32-zlib )
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	elibtoolize
}


src_configure() {
	econf \
		$(use_static) \
		$(use_enable zlib) \
		$(use_enable jpeg) \
		$(use_enable cxx) \
		--without-x \
	|| die
}

src_install() {
	emake DESTDIR="${D}" install || die
	clean_files
}
