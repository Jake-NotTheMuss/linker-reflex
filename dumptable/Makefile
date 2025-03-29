
CC= x86_64-w64-mingw32-gcc

src=dumptable.c

RemoteLogger.dll: $(src)
	$(CC) -DOUTDIR='"$(OUTDIR)"' $(CFLAGS) -o $@ -shared $(src)

clean:
	rm -f RemoteLogger.dll

install:
	-test -e "$${TA_GAME_PATH}bin/RemoteLogger.dll" && \
	cp -f "$${TA_GAME_PATH}bin/RemoteLogger.dll" ./RemoteLogger1.dll
	cp -f RemoteLogger.dll "$${TA_GAME_PATH}bin"

uninstall:
	-test -e RemoteLogger1.dll && \
	mv -f RemoteLogger1.dll "$${TA_GAME_PATH}bin/RemoteLogger.dll"

.PHONY: clean install uninstall
