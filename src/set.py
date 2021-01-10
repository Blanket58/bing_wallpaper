import os

from win32api import RegOpenKeyEx, RegSetValueEx
from win32con import HKEY_CURRENT_USER, KEY_SET_VALUE, REG_SZ, SPIF_SENDWININICHANGE, SPI_SETDESKWALLPAPER
from win32gui import SystemParametersInfo


def main():
    # open register
    regkey = RegOpenKeyEx(HKEY_CURRENT_USER, 'Control Panel\\Desktop', 0, KEY_SET_VALUE)
    RegSetValueEx(regkey, 'WallpaperStyle', 0, REG_SZ, '0')
    RegSetValueEx(regkey, 'TileWallpaper', 0, REG_SZ, '0')
    # refresh screen
    SystemParametersInfo(SPI_SETDESKWALLPAPER, os.path.abspath('cache/cache.jpg'), SPIF_SENDWININICHANGE)


if __name__ == '__main__':
    main()
