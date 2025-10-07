import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: btn
    property color baseColor: "#2196F3"
    property color textColor: "white"

    font.pixelSize: 22
    background: Rectangle {
        color: btn.down ? Qt.darker(baseColor, 1.3) : baseColor
        radius: 12
        border.color: "#0D47A1"
        border.width: 1
    }
    contentItem: Text {
        text: btn.text
        color: textColor
        font.pixelSize: 22
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.centerIn: parent
    }
}
