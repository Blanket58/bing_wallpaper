import win32api
import win32gui
import win32con
def setwallpaper(pic):
  # open register
  regkey = win32api.RegOpenKeyEx(win32con.HKEY_CURRENT_USER,"Control Panel\\Desktop",0,win32con.KEY_SET_VALUE)
  win32api.RegSetValueEx(regkey,"WallpaperStyle", 0, win32con.REG_SZ, "0")
  win32api.RegSetValueEx(regkey, "TileWallpaper", 0, win32con.REG_SZ, "0")
  # refresh screen
  win32gui.SystemParametersInfo(win32con.SPI_SETDESKWALLPAPER,pic, win32con.SPIF_SENDWININICHANGE)
if __name__=='__main__':
  pic='D:/bing_wallpaper-master/bing_wallpaper-master/cache/1.jpg'
  setwallpaper(pic)
