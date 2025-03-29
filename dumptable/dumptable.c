/*
** dumptable.c
** dump flex tables from linker_modtools.exe
*/

#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#ifndef OUTDIR
#define OUTDIR ""
#endif

static void FS_CreatePath (const char *OSPath) {
  void *base = GetModuleHandle(NULL);
  void (*fn) (const char *);
  __asm__("leaq %c1(%2), %0" : "=rm" (fn) : "i" (0x300e10), "r" (base) : );
  (*fn)(OSPath);
}

enum {
  ACCEPT,
  BASE,
  CHK,
  DEF,
  EC,
  META,
  NXT,
  NUM_TABLES
};

static const char *const tabnames [] = {
  "accept", "base", "chk", "def", "ec", "meta", "nxt", NULL
};

struct tabinfo {
  unsigned int offset;
  int size;
  int count;
};

static const struct tabinfo html_tables [NUM_TABLES] = {
  /* ACCEPT */ 0xac4d50, 2, 152,
  /* BASE */   0xac5340, 2, 167,
  /* CHK */    0xac59a0, 2, 476,
  /* DEF */    0xac5490, 2, 167,
  /* EC */     0xac4e80, 4, 256,
  /* META */   0xac5280, 4, 48,
  /* NXT */    0xac55e0, 2, 476
};

static const struct tabinfo scr_tables [NUM_TABLES] = {
  /* ACCEPT */ 0xaf0750, 2, 452,
  /* BASE */   0xaf1040, 2, 473,
  /* CHK */    0xaf21b0, 2, 1270,
  /* DEF */    0xaf1400, 2, 473,
  /* EC */     0xaf0ae0, 4, 256,
  /* META */   0xaf0ee0, 4, 85,
  /* NXT */    0xaf17c0, 2, 1270
};

static const struct tabinfo scr_sym_tables [NUM_TABLES] = {
  /* ACCEPT */ 0xaf8a80, 2, 458,
  /* BASE */   0xaf9380, 2, 482,
  /* CHK */    0xafa540, 2, 1291,
  /* DEF */    0xaf9750, 2, 482,
  /* EC */     0xaf8e20, 4, 256,
  /* META */   0xaf9220, 4, 85,
  /* NXT */    0xaf9b20, 2, 1291
};

static const struct tabinfo sproc_tables [NUM_TABLES] = {
  /* ACCEPT */ 0xac3ef0, 2, 38,
  /* BASE */   0xac43a0, 2, 42,
  /* CHK */    0xac4500, 2, 79,
  /* DEF */    0xac4400, 2, 42,
  /* EC */     0xac3f40, 4, 256,
  /* META */   0xac4340, 4, 24,
  /* NXT */    0xac4460, 2, 79
};

static char *dumptable1 (const char *filename, const struct tabinfo *info) {
  static char buffer [0x400];
  const uintptr_t base = (uintptr_t)GetModuleHandle(NULL);
  FILE *f;
  char *pos = buffer;
  int i;
  *pos = 0;
  FS_CreatePath(filename);
  f = fopen(filename, "wb");
  if (f == NULL) {
    fprintf(stderr, "cannot open file '%s'\n", filename);
    return NULL;
  }
  for (i = 0; i < NUM_TABLES; i++) {
    void *data = (void *)(base + info[i].offset);
    long offset = ftell(f);
    if (offset == -1) {
      fprintf(stderr, "ftell() failed\n");
      return NULL;
    }
    if (pos != buffer) *pos++ = ' ';
    pos += sprintf(pos, "--%s %ld %d", tabnames[i], offset, info[i].size);
    fwrite(data, info[i].size, info[i].count, f);
  }
  fclose(f);
  return buffer;
}

#define dumptable(name, tables, max_state) do { \
  FILE *f; \
  const char *tablefile = OUTDIR "/" name "_flex_tables"; \
  const char *args = dumptable1(tablefile, tables); \
  if (args == NULL) return; \
  f = fopen(OUTDIR "/dump_" name ".sh", "w"); \
  if (f == NULL) return; \
  fprintf(f,"\"$PYTHON\" \"$REFLEX/py/reflex.py\" %s --max-state %d \"%s\" $OUTDIR\n", \
          args, max_state, tablefile); \
  fclose(f); \
} while (0)

static void dumptables (void) {
  dumptable("html", html_tables, 144);
  dumptable("scr", scr_tables, 451);
  dumptable("scr_sym", scr_sym_tables, 457);
  dumptable("sproc", sproc_tables, 39);
}

static int icmp (const char *s1, const char *s2) {
  for (; *s1 && *s2; s1++, s2++) {
    if (tolower(*s1) != tolower(*s2))
      return tolower(*s1) < tolower(*s2) ? -1 : 1;
  }
  return
  (tolower(*s1) == tolower(*s2) ? 0 :
   (tolower(*s1) < tolower(*s2) ? -1 : 1));
}

#ifdef __cplusplus
#define REMOTE_LOGGER_EXPORT extern "C" __declspec(dllexport) __fastcall
#else  /* __cplusplus */
#define REMOTE_LOGGER_EXPORT __declspec(dllexport) __fastcall
#endif /* __cplusplus */

REMOTE_LOGGER_EXPORT void RemoteLogger_Start(const char *program,
                                             const char *version,
                                             const char *buildmachine,
                                             const char *buildtype)
{
  (void)version; (void)buildmachine; (void)buildtype;
  if (icmp(program, "linker") == 0) {
    dumptables();
    ExitProcess(0);
  }
}
