# Appikon

electron-builder henter ikonene herfra (`buildResources: build`).

| Fil | Brukes til |
|-----|------------|
| `icon.svg` | Kilde for de store størrelsene: hvit Sikt-logo på lilla flate |
| `icon-small.svg` | Kilde for 16–64 px (Finder-lister): bare logoen i lilla |
| `icon.icns` | macOS. 16–64 px fra `icon-small.svg`, 128–1024 px fra `icon.svg` |
| `icon.png` | Windows og Linux (1024 px fra `icon.svg`). electron-builder lager `.ico` selv |

`icon.png` og `icon.icns` lages fra SVG-ene. Endrer du dem, render PNG-er i størrelsene under til en mappe `icon.iconset/` (for eksempel med Chrome eller Inkscape), og kjør `iconutil -c icns icon.iconset -o icon.icns`:

```
icon_16x16.png (16)      icon_16x16@2x.png (32)     ← icon-small.svg
icon_32x32.png (32)      icon_32x32@2x.png (64)     ← icon-small.svg
icon_128x128.png (128)   icon_128x128@2x.png (256)  ← icon.svg
icon_256x256.png (256)   icon_256x256@2x.png (512)  ← icon.svg
icon_512x512.png (512)   icon_512x512@2x.png (1024) ← icon.svg
```
