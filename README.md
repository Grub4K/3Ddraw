# 3Ddraw
An educational proof of concept 3D renderer

For more info refer to the [Wiki](https://github.com/Grub4K/3Ddraw/wiki)

## Batch
This implementation is done in Batch.
Run the renderer by calling `3Ddraw.bat` from within the `batch/` directory.
Try to use a square font or font size.

- `batch/`, the source code of the 3D renderer
- `batch/renderer.bat` a pluggable rendering frontend
    - A different renderer can be used as import in `3Ddraw.bat`

## Utils
- `conv.py`, a conversion tool that translates numbers to the internal radix 8 format
- `taylor.py`, a tool to determine the accuracy of the sine taylor polynomial abstraction
- `test_div.py`, a tool to determine the accuracy of the two obvious division algorithms
