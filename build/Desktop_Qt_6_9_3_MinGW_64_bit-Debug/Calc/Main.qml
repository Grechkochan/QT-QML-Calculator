import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "qrc:/content/calculator.js" as CalcEngine

ApplicationWindow {
    id: app
    visible: true
    width: 470
    height: 750
    title: "Калькулятор"
    property bool lastPressedEquals: false
    property string input: ""
    property string result: ""
    property bool waitingForSecret: false
    property string secretInput: ""

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: calculatorPage
    }


    Component {
        id: calculatorPage
        Page {
            background: Rectangle {
                id: backgroundRect
                color: "#024873"
            }

            Rectangle {
                id: topPanel
                width: parent.width + 15
                height: 180
                radius: 45
                color: "#04BFAD"
                border.color: "#355C7D"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: -20

                Column {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 20
                    spacing: 8

                    Item {
                        width: parent.width
                        height: expressionText.paintedHeight

                        Text {
                            id: expressionText
                            text: (input === "" || input === "0") ? "" : input
                            color: "#FFFFFF"
                            font.pixelSize: 24
                            horizontalAlignment: Text.AlignRight
                            anchors.right: parent.right  // ключевое
                            wrapMode: Text.NoWrap
                            elide: Text.ElideRight
                        }
                    }

                    Item {
                        width: parent.width
                        height: resultText.paintedHeight

                        Text {
                            id: resultText
                            text: result === "" ? "0" : result
                            color: "#FFFFFF"
                            font.pixelSize: 36
                            font.bold: true
                            horizontalAlignment: Text.AlignRight
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }

            Grid {
                id: buttonGrid
                                columns: 4
                                anchors.top: topPanel.bottom
                                anchors.topMargin: 30
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                anchors.margins: 20
                                rowSpacing: 24
                                columnSpacing: 24

                Repeater {
                    model: [
                        "()", "±", "%", "÷",
                        "7", "8", "9", "×",
                        "4", "5", "6", "−",
                        "1", "2", "3", "+",
                        "C", "0", ".", "="
                    ]

                    delegate: CalculatorButton {
                        id: calcBtn
                        text: modelData

                        baseColor: text === "C" ? "#F25E5E" :
                                    text === "=" ? "#0889A6" :
                                    ["÷", "×", "−", "+", "%", "±", "()"].indexOf(text) !== -1 ? "#0889A6" :
                                    "#B0D1D8"

                        onClicked: {
                            if (text !== "=")
                                handleButton(text)
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: text === "="
                            property bool holding: false

                            Timer {
                                id: holdTimer
                                interval: 4000
                                repeat: false
                                onTriggered: {
                                    parent.holding = false
                                    waitingForSecret = true
                                    secretInput = ""
                                    secretTimer.start()
                                    console.log("Секретный режим активирован. Введите 123 в течение 5 секунд.")
                                }
                            }

                            onPressed: {
                                    if (text === "=") {
                                        calcBtn.isPressed = true
                                        holdTimer.start() // ваш таймер секретного режима
                                    }
                                }
                            onReleased: {
                                if (text === "=") {
                                    calcBtn.isPressed = false
                                    holdTimer.stop()
                                    if (!waitingForSecret)
                                        handleButton("=")
                                    }
                                }

                            onCanceled: {
                                calcBtn.isPressed = false
                                holdTimer.stop()
                                holding = false
                            }
                        }
                    }
                }
            }

            Timer {
                id: secretTimer
                interval: 5000
                repeat: false
                onTriggered: waitingForSecret = false
            }

            function handleButton(symbol) {
                if (waitingForSecret) {
                    if (symbol >= "0" && symbol <= "9") {
                        secretInput += symbol
                        if (secretInput === "123") {
                            waitingForSecret = false
                            secretTimer.stop()
                            stack.push(secretPage)
                        }
                    }
                    return
                }

                if ((lastPressedEquals || input === "Ошибка") && ((symbol >= "0" && symbol <= "9") || symbol === ".")) {
                    input = ""
                    result = ""
                }

                switch(symbol) {
                case "C":
                    input = ""
                    result = ""
                    lastPressedEquals = false
                    break
                case "=":
                    try {
                        result = CalcEngine.calculateExpression(input)
                    } catch(e) {
                        result = "Ошибка"
                    }
                    lastPressedEquals = true
                    break
                case "±":
                    if (input.length > 0 && input !== "Ошибка") {
                        try {
                            var lastNumber = parseFloat(input.match(/-?\d+(\.\d+)?$/))
                            var negated = -lastNumber
                            input = input.replace(/-?\d+(\.\d+)?$/, negated.toString())
                            result = negated.toString()
                        } catch(e) {
                            input = "Ошибка"
                            result = "Ошибка"
                        }
                    }
                    lastPressedEquals = false
                    break
                case "%":
                    if (input.length > 0 && input !== "Ошибка") {
                        try {
                            var lastNum = parseFloat(input.match(/-?\d+(\.\d+)?$/))
                            var percentValue = lastNum / 100
                            input = input.replace(/-?\d+(\.\d+)?$/, percentValue.toString())
                            result = percentValue.toString()
                        } catch(e) {
                            input = "Ошибка"
                            result = "Ошибка"
                        }
                    }
                    lastPressedEquals = false
                    break
                default:
                    if (input.length < 50 && input !== "Ошибка") { // увеличил лимит, чтобы помещались выражения
                        input += symbol
                        lastPressedEquals = false
                        if (["+", "-", "×", "÷"].indexOf(symbol) !== -1) {
                            try {
                                result = CalcEngine.calculateExpression(input.slice(0, -1))
                            } catch(e) {
                                result = ""
                            }
                        } else {
                            result = input.match(/-?\d+(\.\d+)?$/)[0]
                        }
                    }
                }
            }
        }
    }

    Component {
        id: secretPage
        Page {
            background: Rectangle { color: "#283845" }

            Column {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    text: "Секретное меню"
                    font.pixelSize: 28
                    color: "#FFD700"
                    font.bold: true
                }

                Button {
                    text: "Назад"
                    font.pixelSize: 18
                    background: Rectangle {
                        color: "#2196F3"
                        radius: 10
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        anchors.centerIn: parent
                    }
                    onClicked: stack.pop()
                }
            }
        }
    }
}
