# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit eutils libtool mingw32

DEB_PV="7-1"
DEB_PN="libjpeg7"
DEB="${DEB_PN}_${DEB_PV}"

DESCRIPTION="Library to load, handle and manipulate images in the JPEG format"
HOMEPAGE="http://jpegclub.org/ http://www.ijg.org/"
SRC_URI="
	http://www.ijg.org/files/${M32_PN}src.v${PV}.tar.gz
"

LICENSE="as-is"
SLOT="0"

KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="
"
DEPEND="
	${RDEPEND}
"


src_prepare() {
#	epatch "${WORKDIR}"/${DEB}.diff
	epatch "${FILESDIR}/${M32_PN}-7-maxmem_sysconf.patch"
	mkdir -p debian/extra
#	cp "${FILESDIR}/Makefile.in.extra" debian/extra/Makefile.in
	elibtoolize
#	sed -i '/all:/s:$:\n\t./config.status --file debian/extra/Makefile\n\t$(MAKE) -C debian/extra $@:' Makefile.in
}

src_configure() {
	econf \
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

