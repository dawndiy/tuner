import QtQuick 2.4
import Ubuntu.Components 1.3
import "../component"

Page {
    id: homePage

    header: TunerHeader {
        id: header
        title: i18n.tr("Tuner")

//        StyleHints {
//            foregroundColor: "white"
//            backgroundColor: "#EF6C00"
//            dividerColor: "white"
//        }

        trailingActionBar {
            actions: [
                Action {
                    iconName: "info"
                    text: i18n.tr("About")
                    onTriggered: {
                        adaptivePageLayout.addPageToCurrentColumn(adaptivePageLayout.primaryPage, aboutPage)
                        // rootPageStack.push(aboutPage)
                        // rootPageStack.push(Qt.resolvedUrl("AboutPage.qml"))
                    }
                }
//                Action {
//                    iconName: "media-record"
//                    text: i18n.tr("Record")
//                    onTriggered: {
//                        recorder.record()
//                    }
//                },
//                Action {
//                    iconName: "media-playback-stop"
//                    text: i18n.tr("Stop")
//                    onTriggered: {
//                        recorder.stop()
//                    }
//                }

            ]
        }
    }

    Component.onCompleted: {
        recorder.record();
    }

    Flickable {
        id: flickable
        anchors {
            top: header.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        contentHeight: layout.height

        Item {
            id: tips
            anchors.fill: parent
            Label {
                anchors.centerIn: parent
                width: parent.width
                wrapMode: Text.WordWrap
                text: i18n.tr("Please send your ukulele close to your phone and tuning...")
                fontSize: "x-large"
            }
        }

        Column {
            id: layout
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: units.gu(5)

            Dashboard {
                id: dashboard
                width: parent.width
                height: width / 2
                // height: 400

                property real hzG: 392.00
                property real hzC: 261.63
                property real hzE: 329.63
                property real hzA: 440.00

                Connections {
                    target: recorder
                    onSpectrumChanged: {
                        // dashboard.drawSpectrum(frequencyList, amplitudeList)
                    }
                    onFrequencyChanged: {

                        if (tips.visible) {
                            tips.visible = false;
                        }

                        hertzText.text = Number(frequency).toFixed(2) + " Hz"

                        if (frequency < dashboard.hzC - 30) {
                            // < C
                            dashboard.drawDashboard(135)
                            test.text = "C"
                        } else if (frequency >= dashboard.hzC - 30 && frequency < dashboard.hzC+34 ) {
                            // ~ C ~
                            var d = frequency - dashboard.hzC;
                            if (Math.abs(d) <= 2) {
                                test.color = "green"
                            } else {
                                test.color = ""
                            }

                            d = d * 45/30
                            dashboard.drawDashboard(90 - d);
                            test.text = "C"
                        } else if (frequency >= dashboard.hzE - 32 && frequency < dashboard.hzE + 32) {
                            // ~ E ~
                            var d = frequency - dashboard.hzE;
                            if (Math.abs(d) <= 2) {
                                test.color = "green"
                            } else {
                                test.color = ""
                            }
                            d = d * 45/30
                            dashboard.drawDashboard(90 - d);
                            test.text = "E"
                        } else if (frequency >= dashboard.hzG - 32 && frequency < dashboard.hzG + 32) {
                            // ~ G ~
                            var d = frequency - dashboard.hzG;
                            if (Math.abs(d) <= 2) {
                                test.color = "green"
                            } else {
                                test.color = ""
                            }
                            d = d * 45/30
                            dashboard.drawDashboard(90 - d);
                            test.text = "G"
                        } else if (frequency >= dashboard.hzA - 20 && frequency < dashboard.hzA + 45) {
                            // ~ A ~
                            var d = frequency - dashboard.hzA;
                            if (Math.abs(d) <= 2) {
                                test.color = "green"
                            } else {
                                test.color = ""
                            }
                            d = d * 45/25
                            dashboard.drawDashboard(90 - d);
                            test.text = "A"
                        } else if (frequency > dashboard.hzA - 45) {
                            dashboard.drawDashboard(45)
                            test.text = "A"
                        }

                        // console.log("-------", frequency, test.text)
                    }
                }
            }

            Label {
                id: hertzText
                anchors.horizontalCenter: parent.horizontalCenter
                fontSize: "x-large"
            }

            Label {
                id: test
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: units.gu(20)
            }
        }
    }
}

