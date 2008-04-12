'' examples/manual/gfx/imageconvertrow.bas
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
'' See Also: http://www.freebasic.net/wiki/wikka.php?wakka=KeyPgImageConvertRow
'' --------

#include "fbgfx.bi"
#if __FB_LANG__ = "fb"
Using FB
#endif

Const As Integer w = 64, h = 64
Dim As IMAGE Ptr img8, img32
Dim As Integer x, y


'' create a 32-bit image, size w*h:
ScreenRes 1, 1, 32, , GFX_NULL
img32 = ImageCreate(w, h)

If img32 = 0 Then Print "Imagecreate failed on img32!": Sleep: End


'' create an 8-bit image, size w*h:
ScreenRes 1, 1, 8, , GFX_NULL
img8 = ImageCreate(w, h)

If img8 = 0 Then Print "Imagecreate failed on img8!": Sleep: End


'' fill 8-bit image with a pattern
For y = 0 To h - 1
	For x = 0 To w - 1
	    PSet img8, (x, y), 56 + (x + y) Mod 24
	Next x
Next y


'' open a graphics window in 8-bit mode, and PUT the image into it:
ScreenRes 320, 200, 8
WindowTitle "8-bit color mode"
Put (10, 10), img8

Sleep


'' copy the image data into a 32-bit image
Dim As Byte Ptr p8, p32
Dim As Integer pitch8, pitch32
ImageInfo( img8,  , , , pitch8,  p8  )
ImageInfo( img32, , , , pitch32, p32 )

For y = 0 To h - 1
	ImageConvertRow(@p8 [ y * pitch8 ],  8, _
	                @p32[ y * pitch32], 32, _
	                w)
Next y


'' open a graphics window in 32-bit mode and PUT the image into it:
ScreenRes 320, 200, 32
WindowTitle "32-bit color mode"
Put (10, 10), img32

Sleep


'' free the images from memory:
ImageDestroy img8
ImageDestroy img32
