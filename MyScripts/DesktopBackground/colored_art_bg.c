#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <X11/Xatom.h>
#include "theme.h"

// Hàm cấp phát một pixel màu từ tên màu (ví dụ: "green" hoặc "#00FF00")
unsigned long get_color_pixel(Display *dpy, int screen, const char *color_name) {
    XColor color, exact;
    Colormap cmap = DefaultColormap(dpy, screen);
    if (XAllocNamedColor(dpy, cmap, color_name, &color, &exact)) {
        return color.pixel;
    }
    fprintf(stderr, "Cảnh báo: Không thể cấp phát màu '%s'. Sử dụng màu trắng.\n", color_name);
    return WhitePixel(dpy, screen);
}

// Hàm đọc ASCII art từ một file
char **read_ascii_lines_from_file(const char *filename, int *line_count) {
    FILE *fp = fopen(filename, "r");
    if (fp == NULL) return NULL;

    char **lines = NULL;
    char *line = NULL;
    size_t len = 0;
    ssize_t read;
    int count = 0;

    while ((read = getline(&line, &len, fp)) != -1) {
        if (read > 0 && line[read-1] == '\n') line[read-1] = '\0';

        lines = realloc(lines, sizeof(char*) * (count + 1));
        if (lines == NULL) exit(1);
        
        lines[count] = strdup(line);
        if (lines[count] == NULL) exit(1);
        count++;
    }

    free(line);
    fclose(fp);
    *line_count = count;
    return lines;
}

// Hàm dọn dẹp bộ nhớ mảng các dòng ASCII
void free_ascii_lines(char **lines, int line_count) {
    if (lines == NULL) return;
    for (int i = 0; i < line_count; i++) free(lines[i]);
    free(lines);
}

// Hàm tính toán chiều rộng tối đa (ĐÃ SỬA LỖI BADFONT)
int calculate_max_width(XFontStruct *font_info, char **lines, int line_count) {
    if (!font_info) return 0;

    int max_width = 0;
    for (int i = 0; i < line_count; i++) {
        // Dùng font đã tải để đo chiều rộng chính xác từng dòng
        int current_width = XTextWidth(font_info, lines[i], strlen(lines[i]));
        if (current_width > max_width) max_width = current_width;
    }
    return max_width;
}

int main(int argc, char *argv[]) {
    Display *dpy;
    Window root;
    int screen;
    GC gc;
    XGCValues values;
    Pixmap pmap;
    int width, height;

    const char *filename = "art.txt";

    dpy = XOpenDisplay(NULL);
    if (!dpy) {
        fprintf(stderr, "Lỗi: Không thể kết nối tới X server.\n");
        exit(1);
    }

    screen = DefaultScreen(dpy);
    root = RootWindow(dpy, screen);
    width = DisplayWidth(dpy, screen);
    height = DisplayHeight(dpy, screen);

    int ascii_line_count = 0;
    char **ascii_lines = read_ascii_lines_from_file(filename, &ascii_line_count);
    if (ascii_lines == NULL) {
        fprintf(stderr, "Lỗi: Không thể đọc file ASCII art '%s'.\n", filename);
        XCloseDisplay(dpy);
        exit(1);
    }

    pmap = XCreatePixmap(dpy, root, width, height, DefaultDepth(dpy, screen));
    gc = XCreateGC(dpy, pmap, 0, &values);

 // Tô nền tùy chọn
    XSetForeground(dpy, gc, get_color_pixel(dpy, screen, bg_color)); // <--- THAY MÃ MÀU NỀN TẠI ĐÂY
    XFillRectangle(dpy, pmap, gc, 0, 0, width, height);

    // Cấp màu xanh Matrix cho chữ
    XSetForeground(dpy, gc, get_color_pixel(dpy, screen, fg_color));

    // --- FIX BADFONT: Tải font rõ ràng từ X Server ---
    XFontStruct *font_info = XLoadQueryFont(dpy, "fixed");
    if (!font_info) {
        fprintf(stderr, "Cảnh báo: Không tải được font 'fixed'. Hình sẽ không được căn giữa hoàn hảo.\n");
    } else {
        XSetFont(dpy, gc, font_info->fid); // Ép cọ vẽ dùng font này
    }

    // Tính toán căn giữa dựa trên font đã tải
    int line_height = 15;
    int art_height = ascii_line_count * line_height;
    int art_width = calculate_max_width(font_info, ascii_lines, ascii_line_count);

    int art_x = (width - art_width) / 2;
    int art_y = (height - art_height) / 2;

    // Vẽ từng dòng chữ
    for (int i = 0; i < ascii_line_count; i++) {
        XDrawString(dpy, pmap, gc, art_x, art_y + (i * line_height), ascii_lines[i], strlen(ascii_lines[i]));
    }

    // for picom
    Atom prop_root = XInternAtom(dpy, "_XROOTPMAP_ID", False);
    Atom prop_esetroot = XInternAtom(dpy, "ESETROOT_PMAP_ID", False);

    XChangeProperty(dpy, root, prop_root, XA_PIXMAP, 32, PropModeReplace, (unsigned char *)&pmap, 1);
    XChangeProperty(dpy, root, prop_esetroot, XA_PIXMAP, 32, PropModeReplace, (unsigned char *)&pmap, 1);
    // done

    XSetWindowBackgroundPixmap(dpy, root, pmap);
    XSetCloseDownMode(dpy, RetainPermanent);
    XClearWindow(dpy, root);
    XFlush(dpy);

    // Dọn dẹp an toàn
    if (font_info) {
        XFreeFont(dpy, font_info); // Giải phóng đúng font ID
    }
    XFreeGC(dpy, gc);
    free_ascii_lines(ascii_lines, ascii_line_count);
    XCloseDisplay(dpy);

    printf("Thành công: Đã vẽ ASCII Art lên nền!\n");
    return 0;
}