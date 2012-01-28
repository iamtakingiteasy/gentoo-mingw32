# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

DEB_PV="7-1"
DEB_PN="libjpeg7"
DEB="${DEB_PN}_${DEB_PV}"

inherit eutils libtool mingw32


DESCRIPTION="Library to load, handle and manipulate images in the JPEG format"
HOMEPAGE="http://jpegclub.org/ http://www.ijg.org/"

SRC_URI="
	http://www.ijg.org/files/${M32_PN}src.v${PV}.tar.gz
	mirror://debian/pool/main/libj/${DEB_PN}/${DEB}.diff.gz
"

LICENSE="as-is"

SLOT="0"

KEYWORDS="x86 amd64"

IUSE="+static-libs"

RDEPEND="
"
DEPEND="
"

src_prepare() {
	epatch "${WORKDIR}/${DEB}.diff"
	epatch "${FILESDIR}/${M32_PN}-orig-8b-maxmem_sysconf.patch"
	cp "${FILESDIR}/Makefile.in.extra" debian/extra/Makefile.in || die
	elibtoolize
	sed -i '/all:/s:$:\n\t./config.status --file debian/extra/Makefile\n\t$(MAKE) -C debian/extra $@:' Makefile.in || die
}

src_configure() {
	econf \
		$(use_static) \
		--enable-maxmem=64 \
	|| die
}

src_install() {
	emake DESTDIR="${D}" install || die
	clean_files
}
