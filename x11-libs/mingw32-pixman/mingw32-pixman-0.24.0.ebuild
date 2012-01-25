# Copyright 2012 itakingiteasy
# Distributed under the terms of the WTFPLv2
# $Header:

EAPI=4

inherit autotools autotools-utils toolchain-funcs versionator mingw32

EGIT_REPO_URI="git://anongit.freedesktop.org/git/pixman"


DESCRIPTION="Low-level pixel manipulation routines"

LICENSE="GPL-3"
SLOT="0"

KEYWORDS="x86 amd64"
IUSE="altivec mmx sse2"

RDEPEND=""
DEPEND=""

SRC_URI="http://xorg.freedesktop.org/releases/individual/lib/${M32_P}.tar.bz2"

src_prepare() {
	epatch "${FILESDIR}/${M32_P}-posix-test.patch"
	eautoreconf
}


src_configure() {
	local enable_mmx="$(use mmx && echo 1 || echo 0)"
	local enable_sse2="$(use sse2 && echo 1 || echo 0)"
	if use x86; then
		if use sse2 && ! $(version_is_at_least "4.2" "$(gcc-version)"); then
			ewarn "SSE2 instructions require GCC 4.2 or higher."
			ewarn "pixman will be built *without* SSE2 support"
			enable_sse2="0"
		fi
	fi
	
	local confadd

	case "$enable_mmx,$enable_sse2" in
		"1,1") confadd=(--enable-mmx --enable-sse2)  ;;
		"1,0") confadd=(--enable-mmx --disable-sse2) ;;
		"0,1") 
			ewarn "You enabled SSE2 but have MMX disabled. This is an invalid."
			ewarn "pixman will be built *without* MMX/SSE2 support."
			confadd=(--disable-mmx --disable-sse2) 
		;;
		"0,0") confadd=(--disable-mmx --disable-sse2) ;;
	esac
	
	econf \
		"${confadd[@]}" \
		$(use_enable altivec vmx) \
		--disable-gtk \
		--disable-shared \
	|| die "econf failed"
}

src_compile() {
	autotools-utils_src_compile
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	mingw32_clean_files
}


