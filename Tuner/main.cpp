#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>

#include "audiorecorder.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<AudioRecorder>("AudioRecorder", 1, 0, "Recorder");

    QQuickView view;
    view.setSource(QUrl(QStringLiteral("qrc:///Main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();
    return app.exec();
}

