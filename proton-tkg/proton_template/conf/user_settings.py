#Settings here will take effect for all games run in this Proton version.

user_settings = {
    #Logs are saved to $HOME/steam-<STEAM_GAME_ID>.log, overwriting any previous log with that name.

    #Wine debug logging
#    "WINEDEBUG": "+timestamp,+pid,+tid,+seh,+debugstr,+loaddll,+mscoree",

    #DXVK debug logging
#    "DXVK_LOG_LEVEL": "info",

    #wine-mono debug logging (Wine's .NET replacement)
#    "WINE_MONO_TRACE": "E:System.NotImplementedException",
#    "MONO_LOG_LEVEL": "info",

    #Set DXVK custom config path
#    "DXVK_CONFIG_FILE": "",

    #Enable DXVK Async pipecompiler
#    "PROTON_DXVK_ASYNC": "1",

    #Enable DXVK's HUD
#    "DXVK_HUD": "devinfo,fps",

    #Write the command proton sends to wine for targeted prefix (/prefix/path/launch_command) - Helpful to track bound executable
    "PROTON_LOG_COMMAND_TO_PREFIX": "1",

    #Disable nvapi and nvapi64
    "PROTON_NVAPI_DISABLE": "1",

    #Disable winedbg
    "PROTON_WINEDBG_DISABLE": "1",

    #Enable IMAGE_FILE_LARGE_ADDRESS_AWARE override - Required by some 32-bit games hitting address space issues
#    "PROTON_FORCE_LARGE_ADDRESS_AWARE": "1",

    #Reduce Pulse Latency
    "PROTON_PULSE_LOWLATENCY": "1",

    #Enable Winetricks prompt on game launch
#    "PROTON_WINETRICKS": "1",

    #Use OpenGL-based wined3d for d3d11/d3d10/d3d9 instead of Vulkan-based DXVK & D9VK
#    "PROTON_USE_WINED3D": "1",

    #Use OpenGL-based wined3d for d3d11/10 only (keeping D9VK enabled). Comment out to use Vulkan-based DXVK instead.
#    "PROTON_USE_WINED3D11": "1",

    #Enable custom d3d9 dll usage. This is the option you want to enable to use Gallium 9. Builtin D9VK won't be used with this option enabled.
#    "PROTON_USE_CUSTOMD3D9": "1",

    #Use OpenGL-based wined3d for d3d9 only (keeping DXVK enabled). Comment out to use Vulkan-based D9VK or custom d3d9 dll instead.
    "PROTON_USE_WINED3D9": "1",

    #Use Wine DXGI instead of DXVK's. This is needed to make use of VKD3D when DXVK is enabled. It will prevent the use of DXVK's DXGI functions.
#    "PROTON_USE_WINE_DXGI": "1",

    #Disable d3d11 entirely !!!
#    "PROTON_NO_D3D11": "1",

    #Disable d3d10 entirely !!!
#    "PROTON_NO_D3D10": "1",

    #Disable d3d9 entirely !!!
#    "PROTON_NO_D3D9": "1",

    #Disable eventfd-based in-process synchronization primitives
#    "PROTON_NO_ESYNC": "1",

    #Disable futex-based in-process synchronization primitives
#    "PROTON_NO_FSYNC": "1",
}
