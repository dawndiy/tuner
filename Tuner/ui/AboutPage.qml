import QtQuick 2.4
import Ubuntu.Components 1.3
import "../component"

Page {
    id: aboutPage

    header: TunerHeader {
        id: header
        title: i18n.tr("About")

//        StyleHints {
//            foregroundColor: "white"
//            backgroundColor: "#EF6C00"
//            dividerColor: "white"
//        }

        extension: TunerPageSection {
            id: sections
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }

            actions: [
                Action {
                    text: i18n.tr("About")
                },
                Action {
                    text: i18n.tr("Credits")
                }
            ]
            onSelectedIndexChanged: {
                tabView.currentIndex = selectedIndex
            }

        }
    }

    ListModel {
        id: creditsModel
        Component.onCompleted: initialize()

        function initialize() {
            // Resources
            creditsModel.append({ category: i18n.tr("Resources"), name: i18n.tr("Bugs"), link: "https://github.com/dawndiy/tuner/issues" })
            creditsModel.append({ category: i18n.tr("Resources"), name: i18n.tr("Contact"), link: "mailto:chenglu1990@gmail.com" })

            // Developers
            creditsModel.append({ category: i18n.tr("Developers"), name: "DawnDIY (" + i18n.tr("Founder") + ")", link: "https://github.com/dawndiy" })

            // Logo
            creditsModel.append({ category: i18n.tr("Logo"), name: "Icon made by Freepik from www.flaticon.com ", link: "http://www.flaticon.com/" })

            // Test
            creditsModel.append({ category: i18n.tr("Test"), name: "3D printed Ukulele from uCRobotics Project Viole", link: "http://www.ucrobotics.com/" })
            creditsModel.append({ category: i18n.tr("Test"), name: "Tuner Device from Penk", link: "https://launchpad.net/~penk/" })
        }

    }


    VisualItemModel {
        id: tabs

        Item {
            width: tabView.width
            height: tabView.height

            Flickable {
                id: flickable
                anchors.fill: parent
                contentHeight: layout.height

                Column {
                    id: layout

                    spacing: units.gu(3)
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        topMargin: units.gu(5)
                    }

                    UbuntuShape {
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: width
                        width: Math.min(parent.width/2, parent.height/2)
                        source: Image {
                            source: Qt.resolvedUrl("../Tuner.png")
                        }
                        radius: "large"
                    }

                    Column {
                        width: parent.width
                        Label {
                            width: parent.width
                            textSize: Label.XLarge
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignHCenter
                            text: i18n.tr("Tuner BETA")
                        }
                        Label {
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            // TRANSLATORS: Tuner version number e.g Version 1.0.0
                            text: i18n.tr("Version %1").arg("0.0.2")
                        }
                    }

                    Label {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        text: i18n.tr("A tuner application for Ubuntu Touch.<br/>Now, this is a <b>BETA</b> version for Ukulele, and we will soon support the guitar. :)")
                    }

                    Column {
                        anchors {
                            left: parent.left
                            right: parent.right
                            margins: units.gu(2)
                        }
                        Label {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                            text: "(C) 2016 DawnDIY"
                        }
                        Label {
                            textSize: Label.Small
                            width: parent.width
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                            text: i18n.tr("Released under the terms of the GNU GPL v3")
                        }
                    }

                    Label {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        textSize: Label.Small
                        horizontalAlignment: Text.AlignHCenter
                        linkColor: UbuntuColors.blue
                        text: i18n.tr("Source code available on %1").arg("<a href=\"https://github.com/dawndiy/tuner\">Github</a>")
                        onLinkActivated: Qt.openUrlExternally(link)
                    }

                }
            }
        }

        Item {
            width: tabView.width
            height: tabView.height

            ListView {
                id: creditsListView

                model: creditsModel
                anchors.fill: parent
                section.property: "category"
                section.criteria: ViewSection.FullString
                section.delegate: ListItemHeader {
                    title: section
                }

                delegate: ListItem {
                    height: creditsDelegateLayout.height
                    divider.visible: false
                    ListItemLayout {
                        id: creditsDelegateLayout
                        title.text: model.name
                        ProgressionSlot {}
                    }
                    onClicked: Qt.openUrlExternally(model.link)
                }
            }

        }
    }


    ListView {
        id: tabView
        anchors {
            top: aboutPage.header.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        model: tabs
        currentIndex: 0
        // interactive: false
        orientation: Qt.Horizontal
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: UbuntuAnimation.FastDuration

        onCurrentIndexChanged: {
            sections.selectedIndex = currentIndex
        }

    }
}

