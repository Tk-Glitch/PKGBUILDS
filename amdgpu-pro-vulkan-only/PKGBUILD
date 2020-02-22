# Created by: Tk-Glitch <ti3nou at gmail dot com>

plain '       .---.`               `.---.'
plain '    `/syhhhyso-           -osyhhhys/`'
plain '   .syNMdhNNhss/``.---.``/sshNNhdMNys.'
plain '   +sdMh.`+MNsssssssssssssssNM+`.hMds+'
plain '   :syNNdhNNhssssssssssssssshNNhdNNys:'
plain '    /ssyhhhysssssssssssssssssyhhhyss/'
plain '    .ossssssssssssssssssssssssssssso.'
plain '   :sssssssssssssssssssssssssssssssss:'
plain '  /sssssssssssssssssssssssssssssssssss/'
plain ' :sssssssssssssoosssssssoosssssssssssss:'
plain ' osssssssssssssoosssssssoossssssssssssso'
plain ' osssssssssssyyyyhhhhhhhyyyyssssssssssso'
plain ' /yyyyyyhhdmmmmNNNNNNNNNNNmmmmdhhyyyyyy/'
plain '  smmmNNNNNNNNNNNNNNNNNNNNNNNNNNNNNmmms'
plain '   /dNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNd/'
plain '    `:sdNNNNNNNNNNNNNNNNNNNNNNNNNds:`'
plain '       `-+shdNNNNNNNNNNNNNNNdhs+-`'
plain '             `.-:///////:-.`'

pkgname=amdgpu-pro-vulkan-only
pkgver=19.50.1011208
_pkgveramd=19.50-1011208
pkgrel=1
arch=('x86_64')
url='http://www.amd.com'
license=('custom:AMD')
makedepends=('wget')

DLAGENTS='https::/usr/bin/wget --referer https://www.amd.com/en/support/kb/release-notes/rn-amdgpu-unified-linux.aspx -N %u'

source=(https://drivers.amd.com/drivers/linux/amdgpu-pro-${_pkgveramd}-ubuntu-18.04.tar.xz)
sha256sums=('99a964a9151242f48cf5e40c157dc5147eabc156d8074f9fa2e8de3e81e554de')

# extracts a debian package
# $1: deb file to extract
extract_deb() {
	local tmpdir="$(basename "${1%.deb}")"
	rm -Rf "$tmpdir"
	mkdir "$tmpdir"
	cd "$tmpdir"
	ar x "$1"
	tar -C "${pkgdir}" -xf data.tar.xz
}

package_amdgpu-pro-vulkan-only () {
	pkgdesc="The AMDGPU Pro Vulkan driver, without everything else"
	arch=('x86_64')

	extract_deb "${srcdir}"/amdgpu-pro-${_pkgveramd}-ubuntu-18.04/./vulkan-amdgpu-pro_${_pkgveramd}_amd64.deb
	extract_deb "${srcdir}"/amdgpu-pro-${_pkgveramd}-ubuntu-18.04/./vulkan-amdgpu-pro_${_pkgveramd}_i386.deb

	rm -rf "${pkgdir}"/etc

	msg2 "#################################################################"
	msg2 ""
	msg2 "64-bit loader in /opt/amdgpu-pro/etc/vulkan/icd.d/amd_icd64.json"
	msg2 "32-bit loader in /opt/amdgpu-pro/etc/vulkan/icd.d/amd_icd32.json"
	msg2 ""
	msg2 "64-bit lib in /opt/amdgpu-pro/lib/x86_64-linux-gnu/amdvlk64.so"
	msg2 "32-bit lib in /opt/amdgpu-pro/lib/i386-linux-gnu/amdvlk32.so"
	msg2 ""
	msg2 "changelog and copyright in /usr/share/doc/vulkan-amdgpu-pro"
	msg2 ""
	msg2 "#################################################################"
}
