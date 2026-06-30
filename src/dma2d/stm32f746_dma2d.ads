with Bitmap; use Bitmap;

package STM32F746_DMA2D is

   procedure Initialize;

   procedure Fill
     (Buffer      : Bitmap_Buffer;
      Color       : Bitmap_Color;
      Synchronous : Boolean := False);

   procedure Fill_Rect
     (Buffer      : Bitmap_Buffer;
      Color       : Bitmap_Color;
      X, Y        : Integer;
      Width       : Natural;
      Height      : Natural;
      Synchronous : Boolean := False);

   procedure Copy_Rect
     (Src_Buffer   : Bitmap_Buffer;
      X_Src, Y_Src : Natural;
      Dst_Buffer   : Bitmap_Buffer;
      X_Dst, Y_Dst : Natural;
      Width, Height : Natural;
      Synchronous  : Boolean := False);

   procedure Copy_Rect_Blend
     (Src_Buffer   : Bitmap_Buffer;
      X_Src, Y_Src : Natural;
      Dst_Buffer   : Bitmap_Buffer;
      X_Dst, Y_Dst : Natural;
      Width, Height : Natural;
      Synchronous  : Boolean := False);

   procedure Wait_Transfer;

end STM32F746_DMA2D;
