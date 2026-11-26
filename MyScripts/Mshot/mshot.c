// WARNING: This code write image to stdout for pipeline. So, please use other
// stream for debug printing. (example: stderr)

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <alloca.h>
#include <png.h>
#include <pngconf.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#define F_flag (1 << 0)
#define A_flag (1 << 1)
#define W_flag (1 << 2)
#define S_flag (1 << 3)
#define H_flag (1 << 4)

#define VERSION 1.0

#define min(a, b) ((a > b) ? (b) : (a))
#define max(a, b) ((a > b) ? (a) : (b))

typedef struct {
  png_bytep buffer;
  png_uint_32 bufsize;
} MEMORY_WRITER_STATE;

typedef struct {
  int x, y, w, h;
} Rect;

Rect rect;
Window defaultRoot;
Display *display;
int defaultScreen;
int screenWidth;
int screenHeight;

int Init();
void Parse(int argc, char *argv[], char *flags);
void Close();
void FullScreenShot();
void AreaScreenShot(int new);
void WindowScreenShot();
int WriteToPNG(int width, int height, char *data);
void GetConfigFilePath(char *out_path, int max_len);
int SaveSelection();
void LoadSelection();
void RedrawOverlay(Window *overlay, GC *gc);
void DestroyOverlay(int *running, int *selecting, Window *overlay, GC *gc,
                    Cursor *cursor);

int WriteToPNG(int width, int height, char *data) {
  FILE *file = stdout;

  png_structp png_str =
      png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
  if (!png_str) {
    fprintf(stderr, "Error when creating png_str");
    return 1;
  }

  png_infop png_info = png_create_info_struct(png_str);
  if (!png_info) {
    png_destroy_write_struct(&png_str, (png_infopp)NULL);
    fprintf(stderr, "Error when creating png_info");
    return 1;
  }

  png_init_io(png_str, file);
  png_set_IHDR(
      png_str, png_info, width, height, 8, PNG_COLOR_TYPE_RGB,
      PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_DEFAULT,
      PNG_FILTER_TYPE_DEFAULT); // bit_depth = 8. each R, B, G color has 8 bits.
  png_set_compression_level(png_str, 9);
  png_set_filter(png_str, 0, PNG_ALL_FILTERS);

  png_bytepp row_pointer =
      (png_bytepp)png_malloc(png_str, sizeof(png_bytepp) * height);
  for (int i = 0; i < height; ++i) {
    row_pointer[i] =
        (png_bytep)png_malloc(png_str, width * 3); // 3 color R, B, G
  }

  for (int hi = 0; hi < height; ++hi) {
    for (int wi = 0; wi < width; ++wi) {
      int src_id = (wi + width * hi) * 4; // 3 color + 1 alpha
      int dst_id = wi * 3;

      row_pointer[hi][dst_id + 0] = data[src_id + 2]; // R
      row_pointer[hi][dst_id + 1] = data[src_id + 1]; // G
      row_pointer[hi][dst_id + 2] = data[src_id + 0]; // B
    }
  }

  png_write_info(png_str, png_info);
  png_write_image(png_str, row_pointer);
  png_write_end(png_str, png_info);
  png_destroy_write_struct(&png_str, &png_info);

  return 0;
}

void GetConfigFilePath(char *out_path, int max_len) {
  const char *home = getenv("HOME");
  char dir_path[512];

  if (home && strlen(home) > 0) {
    snprintf(dir_path, sizeof(dir_path), "%s/.config/mshot", home);
  } else {
    snprintf(dir_path, sizeof(dir_path), "./.config/mshot");
  }
  mkdir(dir_path, 0700);
  snprintf(out_path, max_len, "%s/mshot.cfg", dir_path);
}

int SaveSelection() {
  char filepath[512];
  GetConfigFilePath(filepath, sizeof(filepath));

  FILE *file = fopen(filepath, "w");
  if (!file) {
    fprintf(stderr, "Cannot open file for saving config\n");
    return 1;
  }

  fprintf(file, "%d %d %d %d", rect.x, rect.y, rect.w, rect.h);
  fclose(file);
  return 0;
}

void LoadSelection() {
  rect.x = 0;
  rect.y = 0;
  rect.w = 800;
  rect.h = 600;
  char filepath[512];
  GetConfigFilePath(filepath, sizeof(filepath));

  FILE *file = fopen(filepath, "r");
  if (!file)
    return;
  fscanf(file, "%d %d %d %d", &rect.x, &rect.y, &rect.w, &rect.h);
}

void FullScreenShot() {
  XImage *image = XGetImage(display, defaultRoot, 0, 0, screenWidth,
                            screenHeight, AllPlanes, ZPixmap);
  WriteToPNG(screenWidth, screenHeight, image->data);
  XDestroyImage(image);
}

void RedrawOverlay(Window *overlay, GC *gc) {
  static Rect old = {0}; // Remaining values
  XDrawRectangle(display, *overlay, *gc, old.x, old.y, old.w,
                 old.h); // Cancel old border
  XDrawRectangle(display, *overlay, *gc, rect.x, rect.y, rect.w,
                 rect.h); // New border
  old = (Rect){rect.x, rect.y, rect.w, rect.h};
  XFlush(display);
}

void DestroyOverlay(int *running, int *selecting, Window *overlay, GC *gc,
                    Cursor *cursor) {
  *running = 0;
  *selecting = 0;
  XUngrabPointer(display, CurrentTime);
  XUngrabKeyboard(display, CurrentTime);
  XFreeCursor(display, *cursor);
  XDestroyWindow(display, *overlay);
  XFreeGC(display, *gc);
}

void AreaScreenShot(int new) {
  XImage *image;

  if (new) {
    XVisualInfo visinfo = {};
    if (!XMatchVisualInfo(display, defaultScreen, 24, TrueColor,
                          &visinfo)) { // depth = 24 (RBG)
      fprintf(stderr, "No matching visual info\n");
      return;
    }

    XSetWindowAttributes windowAttr;
    windowAttr.background_pixmap = None;
    windowAttr.override_redirect = True;
    windowAttr.event_mask = ExposureMask | KeyPressMask;
    unsigned long attributeMask =
        CWOverrideRedirect | CWBackPixmap | CWEventMask;

    Window overlay = XCreateWindow(display, defaultRoot, 0, 0, screenWidth,
                                   screenHeight, 0, visinfo.depth, InputOutput,
                                   visinfo.visual, attributeMask, &windowAttr);
    XMapRaised(display, overlay);

    Cursor cursor =
        XCreateFontCursor(display, 34); // 34 = XC_crosshair <X11/cursorfont.h>

    if (XGrabPointer(display, overlay, True,
                     ButtonPressMask | ButtonReleaseMask | PointerMotionMask,
                     GrabModeAsync, GrabModeAsync, None, cursor,
                     CurrentTime) != GrabSuccess) {
      fprintf(stderr, "Failed to grab pointer\n");
      XFreeCursor(display, cursor);
      return;
    }

    if (XGrabKeyboard(display, overlay, True, GrabModeAsync, GrabModeAsync,
                      CurrentTime) != GrabSuccess) {
      fprintf(stderr, "Failed to grab keyboard\n");
      return;
    }

    XEvent event;
    XGCValues gvalues;
    gvalues.function = GXxor;
    gvalues.foreground = WhitePixel(display, defaultScreen);
    GC gc = XCreateGC(display, overlay, GCFunction | GCForeground, &gvalues);
    int x1, x2, y1, y2;
    int running = 1;
    int selecting = 0;

    while (running) {
      XNextEvent(display, &event);

      switch (event.type) {

      case KeyPress: {
        DestroyOverlay(&running, &selecting, &overlay, &gc, &cursor);
        break;
      }
      case Expose: {
        RedrawOverlay(&overlay, &gc);
        break;
      }
      case ButtonPress: {
        x1 = x2 = event.xbutton.x_root;
        y1 = y2 = event.xbutton.y_root;
        selecting = 1;
        break;
      }
      case ButtonRelease: {
        // Drawing to XOR all rectangle (like RedrawOverlay function)
        // Why not DestroyOverlay then XGetImage?
        // - They are asynchonous, so it is possible that they would cause
        // unexpected behaviour. It is also because of that Composition can mess
        // things up (my picom make my image empty somehow).
        XDrawRectangle(display, overlay, gc, rect.x, rect.y, rect.w, rect.h);
        XFlush(display);

        if (rect.w > 0 && rect.h > 0) {
          XImage *image = XGetImage(display, defaultRoot, rect.x, rect.y,
                                    rect.w, rect.h, AllPlanes, ZPixmap);
          WriteToPNG(rect.w, rect.h, image->data);
          XDestroyImage(image);
        }
        DestroyOverlay(&running, &selecting, &overlay, &gc, &cursor);

        if (SaveSelection()) {
          fprintf(stderr, "Failed to save selection\n");
          return;
        }
        break;
      }
      case MotionNotify: {
        if (selecting) {
          do { // Only draw newest rect
            x2 = event.xmotion.x;
            y2 = event.xmotion.y;
          } while (XCheckTypedEvent(display, MotionNotify, &event));

          rect = (Rect){min(x1, x2), min(y1, y2), abs(x2 - x1), abs(y2 - y1)};
          RedrawOverlay(&overlay, &gc);
        }
        break;
      }
      }
    }
  } else {
    LoadSelection();
    XImage *image = XGetImage(display, defaultRoot, rect.x, rect.y, rect.w,
                              rect.h, AllPlanes, ZPixmap);
    WriteToPNG(rect.w, rect.h, image->data);
    XDestroyImage(image);
  }
}

void WindowScreenShot() {
  Window window;
  int revert_to_temp;

  XGetInputFocus(display, &window, &revert_to_temp);
  if (!window) {
    fprintf(stderr, "No focused window\n");
    return;
  }

  XWindowAttributes windowAttr;
  if (!XGetWindowAttributes(display, window, &windowAttr)) {
    fprintf(stderr, "Can not get window attributes\n");
    return;
  }

  XImage *image = XGetImage(display, window, 0, 0, windowAttr.width,
                            windowAttr.height, AllPlanes, ZPixmap);
  if (!image) {
    fprintf(stderr, "Failed to get image\n");
    return;
  }

  WriteToPNG(windowAttr.width, windowAttr.height, image->data);
  XDestroyImage(image);

  //
  //
  // NOTE: Some conversion that i think i will need in the future

  // WriteToPNG requires data with depth = 32 (RGBA) (wrong) but window manager
  // is using 24 depth so XGetImage will capture 24 depth image (No it's good,
  // so i recenly don't need these code)

  // char *data32bit = malloc(windowAttr.width * windowAttr.height * 4);
  // if (!data32bit) {
  //   fprintf(stderr, "Failded to malloc for data32bit\n");
  //   XDestroyImage(image);
  //   return;
  // }

  //
  // int dst_id = 0;
  // unsigned long pixel;
  // for (int i = 0; i < windowAttr.height; ++i)
  //   for (int j = 0; j < windowAttr.width; ++j) {
  //     pixel = XGetPixel(image, j, i);
  //     data32bit[dst_id + 0] = (pixel & image->blue_mask);
  //     data32bit[dst_id + 1] = (pixel & image->green_mask) >> 8;
  //     data32bit[dst_id + 2] = (pixel & image->red_mask) >> 16;
  //     data32bit[dst_id + 3] = 0xFF;
  //     dst_id += 4;
  //   }

  // WriteToPNG(windowAttr.width, windowAttr.height, data32bit);
  // free(data32bit);
  // XDestroyImage(image);
}

void Parse(int argc, char *argv[], char *flags) {
  if (argc > 1) {
    for (int i = 0; i < argc; ++i) {
      if (strcmp(argv[i], "-f") == 0)
        *flags |= F_flag;
      if (strcmp(argv[i], "-a") == 0)
        *flags |= A_flag;
      if (strcmp(argv[i], "-w") == 0)
        *flags |= W_flag;
      if (strcmp(argv[i], "-s") == 0)
        *flags |= S_flag;
      if (strcmp(argv[i], "-h") == 0)
        *flags |= H_flag;
    }
  }
}

int Init() {
  display = XOpenDisplay(NULL);
  if (!display) {
    fprintf(stderr, "No display available\n");
    return 1;
  }
  defaultRoot = XDefaultRootWindow(display);
  defaultScreen = XDefaultScreen(display);
  screenWidth = XDisplayWidth(display, defaultScreen);
  screenHeight = XDisplayHeight(display, defaultScreen);

  return 0;
}

void Close() { XCloseDisplay(display); }

int main(int argc, char *argv[]) {
  char flags = 0;
  Parse(argc, argv, &flags);
  if (Init())
    return 1;

  switch (flags) {
  case F_flag: {
    FullScreenShot();
    break;
  }
  case A_flag: {
    AreaScreenShot(0);
    break;
  }
  case A_flag | S_flag: {
    AreaScreenShot(1);
    break;
  }
  case W_flag: {
    WindowScreenShot();
    break;
  }
  case H_flag: {
    printf("Version: %.1f\n"
           "Flags:\n"
           "  -h: help\n"
           "  -f: fullscreen mode\n"
           "  -a: area mode\n"
           "  -w: window mode\n"
           "  -s: select new area (-a mode)\n",
           VERSION);
    break;
  }
  default:
    fprintf(stderr, "Invalid flags, use -h for help\n");
    return 1;
    break;
  }

  Close();
  return 0;
}
