# vkd3d-git patches

- 01-wow-flicker-fix.myvkd3dpatch : Fixes flickering with WoW dx12 renderer
- Support_RS_1.0_Volatile.myvkd3dpatch : Required to fix a crash in WoW's Nazjatar zone when using dx12 - https://www.winehq.org/pipermail/wine-devel/2019-November/153658.html - **Depends on a wine build patched with [D3D12CreateVersionedRootSignatureDeserializer](https://github.com/Tk-Glitch/PKGBUILDS/blob/master/community-patches/wine-tkg-git/D3D12CreateVersionedRootSignatureDeserializer.mypatch) and [D3D12SerializeVersionedRootSignature](https://github.com/Tk-Glitch/PKGBUILDS/blob/master/community-patches/wine-tkg-git/D3D12SerializeVersionedRootSignature.mypatch) patches**
