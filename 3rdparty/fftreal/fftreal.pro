#-------------------------------------------------
#
# Project created by QtCreator 2016-04-05T23:45:47
#
#-------------------------------------------------

TARGET = fftreal
TEMPLATE = lib

# FFTReal
HEADERS  += Array.h \
            Array.hpp \
            DynArray.h \
            DynArray.hpp \
            FFTRealFixLen.h \
            FFTRealFixLen.hpp \
            FFTRealFixLenParam.h \
            FFTRealPassDirect.h \
            FFTRealPassDirect.hpp \
            FFTRealPassInverse.h \
            FFTRealPassInverse.hpp \
            FFTRealSelect.h \
            FFTRealSelect.hpp \
            FFTRealUseTrigo.h \
            FFTRealUseTrigo.hpp \
            OscSinCos.h \
            OscSinCos.hpp \
            def.h

HEADERS += fftreal_wrapper.h
SOURCES += fftreal_wrapper.cpp

DEFINES += FFTREAL_LIBRARY

unix {
    target.path = /usr/lib
    INSTALLS += target
}

DISTFILES += \
    ../../tuner/ui/HomePage.qml
