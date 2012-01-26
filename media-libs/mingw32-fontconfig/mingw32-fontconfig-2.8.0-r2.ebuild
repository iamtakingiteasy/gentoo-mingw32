# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit autotools eutils libtool toolchain-funcs flag-o-matic mingw32

DESCRIPTION="A library for configuring and customizing font access"
HOMEPAGE="http://fontconfig.org/"
SRC_URI="
	http://fontconfig.org/release/${M32_P}.tar.gz
"

LICENSE="MIT"
SLOT="1.0"

KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="
	media-libs/mingw32-freetype
	dev-libs/mingw32-expat
	app-arch/mingw32-bzip2
"
DEPEND="
	${RDEPEND}
"


src_prepare() {
	epatch "${FILESDIR}/${M32_PN}-2.7.1-latin-reorder.patch"
	epatch "${FILESDIR}/${M32_PN}-2.3.2-docbook.patch"
	epatch "${FILESDIR}/${M32_PN}-2.8.0-urw-aliases.patch" 
	epatch "${FILESDIR}/${M32_PN}-2.8.0-install.patch" 
	epatch "${FILESDIR}/${M32_PN}-2.8.0-pkgconfig.patch" 
	eautoreconf
	elibtoolize
}

src_configure() {
	econf \
		--disable-shared \
		--with-arch=${ARCH} \
	|| die "econf failed"
}

src_compile() {
	emake \
		CFLAGS= \
	|| die "emake failed"
}


src_install() {
	emake -j1 DESTDIR="${D}" install || die "emake install"
	clean_files
}

