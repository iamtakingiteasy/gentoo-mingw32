# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header: $

EAPI=4

inherit autotools eutils libtool mingw32

DESCRIPTION="Version 2 of the library to manipulate XML files"
HOMEPAGE="http://www.xmlsoft.org/"

SRC_URI="
	ftp://xmlsoft.org/${M32_PN}/${M32_P}.tar.gz
"

LICENSE="MIT"

SLOT="2"

KEYWORDS="x86 amd64"

IUSE="+static-libs +ipv6"

RDEPEND="
	sys-libs/mingw32-zlib
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	epatch "${FILESDIR}/${M32_PN}-orig-2.7.8-catalog_path.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-2.7.8-winnt.patch"

	eprefixify catalog.c xmlcatalog.c runtest.c xmllint.c

	epatch "${FILESDIR}/${M32_PN}-orig-2.7.8-reactivate-script.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-2.7.8-xpath-memory.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-2.7.8-xpath-freeing.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-2.7.8-xpath-freeing2.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-2.7.8-reallocation-failures.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-2.7.8-disable_static_modules.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-2.7.8-hardening-xpath.patch"
	epatch "${FILESDIR}/${M32_PN}-orig-2.7.8-error-xpath.patch"

	sed -e "s/@PYTHON_SUBDIR@//" -i Makefile.am || die "sed failed"
	
	eautoreconf
}

src_configure() {
	filter-flags -fprefetch-loop-arrays -funroll-loops

	econf \
		$(use_static) \
		$(use_enable ipv6) \
	|| die
}

src_install() {
	emake DESTDIR="${D}" install || die
	clean_files	
}
