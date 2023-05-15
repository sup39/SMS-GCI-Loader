#include "sms.h"
#include "drawText.h"

void drawText(DrawTextOpt *opt, const char *fmt, ...) {
  J2DPrint printer;

  va_list args;
  va_start(args, fmt);

  // new J2DPrinter
  new_J2DPrint(&printer, gpSystemFont, 0, opt->fontSize, &opt->colorTop, &opt->colorBot);
  printer.fontWidth = printer.fontHeight = opt->fontSize;

  // set coordinate
  printer.xInt = opt->x;
  // printer.yInt = opt->y; // (actually unused)
  printer.xFloat = opt->x;
  printer.yFloat = opt->y;
  printer.zFloat = 0;

  // print text
  J2DPrint_print_alpha_va(&printer, 0xff, fmt, args);
  va_end(args);

  // no need to delete if not allocating memory from heap
  // delete_J2DPrint(&printer, -1);
}
