import QtQuick 2.4
import Ubuntu.Components 1.3
import AudioRecorder 1.0
import Ubuntu.PerformanceMetrics 1.0
import "ui"

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "tuner.ubuntu-dawndiy"

    width: units.gu(50)
    height: units.gu(75)

    Recorder {
        id: recorder

//        onSpectrumChanged: {
////            console.log(frequencyList.length, amplitudeList.length)

//        }
    }

    AdaptivePageLayout {
        id: adaptivePageLayout

        anchors.fill: parent
        primaryPage: homePage

        layouts: PageColumnsLayout {
//            when: width > units.gu(80)
//            // column #0
//            PageColumn {
//                minimumWidth: units.gu(80)
//                maximumWidth: units.gu(90)
//                preferredWidth: units.gu(40)
//            }
            // column #1
            PageColumn {
                fillWidth: true
            }
        }

        HomePage {
            id: homePage
        }

        AboutPage {
            id: aboutPage
        }
    }

//    PageStack {
//        id: rootPageStack
//        anchors.fill: parent

//        Component.onCompleted: {
//            push(homePage)
//        }

//        HomePage {
//            id: homePage
//            visible: false
//        }

//    }

    PerformanceOverlay {
        active: false
    }
}

