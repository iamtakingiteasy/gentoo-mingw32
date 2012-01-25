# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit eutils toolchain-funcs mingw32


DESCRIPTION="data compression algorithm for bi-level high-resolution images"
HOMEPAGE="http://www.cl.cam.ac.uk/~mgk25/jbigkit/"
SRC_URI="
	http://www.cl.cam.ac.uk/~mgk25/download/${M32_P}.tar.gz
"

S=${WORKDIR}/${M32_PN}

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
	epatch "${FILESDIR}/${M32_P}-r1-build.patch"
}

src_configure() {
	econf \
		--disable-shared \
	|| die "econf failed"
}

src_compile() {
	tc-export AR CC RANLIB
	emake LIBDIR="${EPREFIX}/usr/$(get_libdir)" || die
}



src_install() {
	dobin pbmtools/jbgtopbm{,85} pbmtools/pbmtojbg{,85} || die
	insinto ${ROOT}usr/include
	doins libjbig/*.h || die
	dolib libjbig/libjbig{,85}.a || die
	clean_files
}

