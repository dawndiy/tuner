TEMPLATE = app
TARGET = Tuner

load(ubuntu-click)

QT += qml quick multimedia

SOURCES += main.cpp \
    audiorecorder.cpp \
    spectrumanalyser.cpp \
    frequencyspectrum.cpp \
    utils.cpp


RESOURCES += Tuner.qrc

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  Tuner.apparmor \
               Tuner.png

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)

#show all the files in QtCreator
OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               Tuner.desktop

#specify where the config files are installed to
config_files.path = /Tuner
config_files.files += $${CONF_FILES}
INSTALLS+=config_files

#install the desktop file, a translated version is 
#automatically created in the build directory
desktop_file.path = /Tuner
desktop_file.files = $$OUT_PWD/Tuner.desktop
desktop_file.CONFIG += no_check_exist
INSTALLS+=desktop_file

# Default rules for deployment.
target.path = $${UBUNTU_CLICK_BINARY_PATH}
INSTALLS+=target

HEADERS += \
    audiorecorder.h \
    spectrumanalyser.h \
    frequencyspectrum.h \
    utils.h \
    spectrum.h

fftreal_dir = ../3rdparty/fftreal

INCLUDEPATH += $${fftreal_dir}

DISTFILES += \
    ui/HomePage.qml \
    ui/AboutPage.qml \
    component/ListItemHeader.qml \
    component/Dashboard.qml \
    component/TunerHeader.qml \
    component/TunerHeaderButton.qml \
    component/TunerPageSection.qml
