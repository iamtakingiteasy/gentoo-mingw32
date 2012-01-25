# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit autotools eutils flag-o-matic libtool prefix mingw32

DESCRIPTION="Version 2 of the library to manipulate XML files"
HOMEPAGE="http://www.xmlsoft.org/"
SRC_URI="http://xmlsoft.org/${M32_PN}/${M32_P}.tar.gz"

LICENSE="MIT"
SLOT="2"

KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="
	sys-libs/mingw32-zlib
"
DEPEND="
	${RDEPEND}
"


src_prepare() {
	epatch "${FILESDIR}/${M32_PN}-2.7.1-catalog_path.patch"
	epatch "${FILESDIR}/${M32_PN}-2.7.2-winnt.patch"
	
	eprefixify catalog.c xmlcatalog.c runtest.c xmllint.c
	
	epatch "${FILESDIR}/${M32_P}-reactivate-script.patch"
	epatch "${FILESDIR}/${M32_P}-xpath-memory.patch"
	epatch "${FILESDIR}/${M32_P}-xpath-freeing.patch"
	epatch "${FILESDIR}/${M32_P}-xpath-freeing2.patch"
	epatch "${FILESDIR}/${M32_P}-reallocation-failures.patch"
	epatch "${FILESDIR}/${M32_P}-disable_static_modules.patch"
	epatch "${FILESDIR}/${M32_P}-hardening-xpath.patch"
	epatch "${FILESDIR}/${M32_P}-error-xpath.patch"

	sed -e "s/@PYTHON_SUBDIR@//" -i Makefile.am || die "sed failed"
	
	eautoreconf
}

src_configure() {
	filter-flags -fprefetch-loop-arrays -funroll-loops

	econf \
		--disable-shared \
		--without-debug \
		--without-python \
		--without-threads \
	|| die "econf failed"

}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	rm -r "${D}usr/share/gtk-doc"
		
	clean_files
}

