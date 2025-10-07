import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: btn
    width: 90
    height: 90
    radius: width / 2
    property alias text: label.text
    property color baseColor: "#2196F3"
    property color textColor: "white"

    property bool isPressed: false

    color: isPressed ? "#F7E425" : baseColor

    Text {
        id: label
        anchors.centerIn: parent
        text: "0"
        color: textColor
        font.pixelSize: 26
        font.bold: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPressed: {
            isPressed = true
            btn.pressed()
        }
        onReleased: {
            isPressed = false
            btn.released()
        }
        onCanceled: {
            isPressed = false
            btn.released()
        }
        onClicked: btn.clicked()
    }

    signal clicked()
    signal pressed()
    signal released()
}
