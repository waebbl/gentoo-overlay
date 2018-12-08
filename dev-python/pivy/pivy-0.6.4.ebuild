# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Coin3D bindings for Python"
HOMEPAGE="https://pivy.coin3d.org/"
SRC_URI="https://github.com/FreeCAD/pivy/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

#S="${WORKDIR}/Coin3D-pivy-a84100beff22"

RDEPEND="
	media-libs/coin:=
	media-libs/SoQt:=
"
DEPEND="
	${RDEPEND}
	dev-lang/swig
"
