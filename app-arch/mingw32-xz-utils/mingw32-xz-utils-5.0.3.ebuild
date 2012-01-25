# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4



inherit eutils mingw32

MY_P="${M32_PN/-utils}-${PV/_}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="utils for managing LZMA compressed files"
HOMEPAGE="http://tukaani.org/xz/"
SRC_URI="http://tukaani.org/xz/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="x86 amd64"
IUSE="nls +threads"

RDEPEND=""
DEPEND="
	${RDEPEND}
"



src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable threads) \
	|| die "econf failed"

}


src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	rm -r "${D}/usr/share/doc" || die 
	mingw32_clean_files
}

