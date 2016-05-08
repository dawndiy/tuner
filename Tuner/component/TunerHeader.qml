import QtQuick 2.4
import Ubuntu.Components 1.3

PageHeader {
    StyleHints {
        backgroundColor: "#EF6C00"
        foregroundColor: "White"
        dividerColor: "White"
    }

    trailingActionBar.delegate: TunerHeaderButton {}
    leadingActionBar.delegate: TunerHeaderButton {}
}
