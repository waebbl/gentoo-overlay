# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# The ebuild was copied over from the Drauthius overlay, slightly
# modified and moved to a sensible category.
# See https://anongit.gentoo.org/git/repo/user/Drauthius.git for the
# original ebuild.
# Thanks to Albert Diserholt for creating the original ebuild.

EAPI=7

# Putting long description into metadata.xml, as repoman restricts
# descriptions to max. 80 chars.
MY_PV=${PV}-0${PVR:5}
DESCRIPTION="SimulationCraft is a tool to explore combat mechanics in World of Warcraft."
HOMEPAGE="http://simulationcraft.org/"
SRC_URI="https://github.com/${PN}/simc/archive/release-${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +gui"

RDEPEND="
	dev-libs/openssl:=
	gui? (
		dev-qt/qtchooser
		dev-qt/qtcore:5=
		dev-qt/qtgui:5=
		dev-qt/qtnetwork:5=
		dev-qt/qtwebengine:5=
		dev-qt/qtwidgets:5=
	)
"
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )
"

S="${WORKDIR}/simc-release-${MY_PV}"

src_configure() {
	use gui && qtchooser -run-tool=qmake -qt=5 simcqt.pro PREFIX="${D}/usr" CONFIG+=openssl LIBS+="-lssl"
}

src_compile() {
	emake -C engine OPENSSL=1 optimized || die "Building engine failed"
	use gui && emake || die "Building GUI failed"
	use doc && (cd doc && doxygen Doxyfile) || die "Building documentation failed"
}

src_install() {
	exeinto /usr/bin
	doexe "${S}"/engine/simc
	use gui && emake DESTDIR="${D}" install || die "Install failed"
	if use doc; then
		HTML_DOCS=( doc/doxygen/html/. )
		einstalldocs
		mv "${D}/usr/share/SimulationCraft/SimulationCraft/Error.html" "${D}/usr/share/doc/${PF}/html"
		mv "${D}/usr/share/SimulationCraft/SimulationCraft/Welcome.html" "${D}/usr/share/doc/${PF}/html"
		mv "${D}/usr/share/SimulationCraft/SimulationCraft/Welcome.png" "${D}/usr/share/doc/${PF}/html"
		ln -s "../../doc/${PF}/html/Error.html" "${D}/usr/share/SimulationCraft/SimulationCraft/Error.html"
		ln -s "../../doc/${PF}/html/Welcome.html" "${D}/usr/share/SimulationCraft/SimulationCraft/Welcome.html"
		ln -s "../../doc/${PF}/html/Welcome.png" "${D}/usr/share/SimulationCraft/SimulationCraft/Welcome.png"
	fi
}

pkg_postinst() {
	elog "You will need to obtain an API key if you wish to import from the"
	elog "WoW armory."
	elog "Follow the instructions here:"
	elog "  https://github.com/simulationcraft/simc/wiki/BattleArmoryAPI"
}
