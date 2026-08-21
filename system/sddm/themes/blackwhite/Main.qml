/***************************************************************************
* Copyright (c) 2013 Reza Fatahilah Shah <rshah0385@kireihana.com>
* Copyright (c) 2013 Abdurrahman AVCI <abdurrahmanavci@gmail.com>
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
* OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
* OR OTHER DEALINGS IN THE SOFTWARE.
*
***************************************************************************/

import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    width: 640
    height: 480

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index

Timer {
    interval: 1000
    running: true
    repeat: true

    onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm")
}

    TextConstants { id: textConstants }

    Connections {
        target: sddm
        onLoginSucceeded: {
        }
        onInformationMessage: {
        }
        onLoginFailed: {
            pw_entry.text = ""
        }
    }

    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    Rectangle {
        anchors.fill: parent
	color: "#55000000"
        //visible: primaryScreen

Rectangle {
    id: loginCard

    width: 420
    height: 520

    color: "#99000000"

    border.color: "#66ffffff"
    border.width: 1
    radius: 8

    anchors.centerIn: parent

    Item {
        anchors.fill: parent
        anchors.margins: 30

        Timer {
            interval: 1000
            running: true
            repeat: true

            onTriggered: {
                clock.text = Qt.formatDateTime(new Date(), "HH:mm")
                dateText.text = Qt.formatDateTime(new Date(), "dddd, dd MMMM yyyy")
            }
        }

        Text {
            id: clock

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 5

            color: "#ffffff"

            font.family: "JetBrains Mono"
            font.pixelSize: 42
            font.bold: true

            text: Qt.formatDateTime(new Date(), "HH:mm")
        }

        Text {
            id: dateText

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: clock.bottom
            anchors.topMargin: 10

            color: "#b0ffffff"

            font.family: "JetBrains Mono"
            font.pixelSize: 14

            text: Qt.formatDateTime(new Date(), "dddd, dd MMMM yyyy")
        }

        Text {
            id: userLabel

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 125

            text: "USER"

            color: "#80ffffff"

            font.family: "JetBrains Mono"
            font.pixelSize: 11
            font.bold: true
        }

        Rectangle {
            id: userBox

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: userLabel.bottom
            anchors.topMargin: 7

            width: 260
            height: 42

            color: "#99000000"

            border.color: "#ffffff"
            border.width: 1
            radius: 5

            TextInput {
                id: user_entry

                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12

                verticalAlignment: TextInput.AlignVCenter

                text: userModel.lastUser

                color: "#ffffff"

                font.family: "JetBrains Mono"
                font.pixelSize: 16
                font.bold: true

                selectByMouse: true

                KeyNavigation.backtab: layoutBox
                KeyNavigation.tab: pw_entry
            }
        }

        Text {
            id: passwordLabel

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: userBox.bottom
            anchors.topMargin: 17

            text: "PASSWORD"

            color: "#80ffffff"

            font.family: "JetBrains Mono"
            font.pixelSize: 11
            font.bold: true
        }

        Rectangle {
            id: passwordBox

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: passwordLabel.bottom
            anchors.topMargin: 7

            width: 260
            height: 42

            color: "#99000000"

            border.color: "#ffffff"
            border.width: 1
            radius: 5

            TextInput {
                id: pw_entry

                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12

                verticalAlignment: TextInput.AlignVCenter

                echoMode: TextInput.Password

                color: "#ffffff"

                font.family: "JetBrains Mono"
                font.pixelSize: 16

                selectByMouse: true

                KeyNavigation.backtab: user_entry
                KeyNavigation.tab: login_button

                Keys.onPressed: {
                    if (event.key === Qt.Key_Return ||
                        event.key === Qt.Key_Enter) {

                        sddm.login(
                            user_entry.text,
                            pw_entry.text,
                            sessionIndex
                        )

                        event.accepted = true
                    }
                }
            }
        }

        Rectangle {
            id: login_button

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: passwordBox.bottom
            anchors.topMargin: 22

            width: 260
            height: 42

            color: loginMouse.containsMouse
                   ? "#ccffffff"
                   : "#99000000"

            border.color: "#ffffff"
            border.width: 1
            radius: 5

            Text {
                anchors.centerIn: parent

                text: "LOGIN"

                color: loginMouse.containsMouse
                       ? "#000000"
                       : "#ffffff"

                font.family: "JetBrains Mono"
                font.pixelSize: 14
                font.bold: true
            }

            MouseArea {
                id: loginMouse

                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    sddm.login(
                        user_entry.text,
                        pw_entry.text,
                        sessionIndex
                    )
                }
            }

            KeyNavigation.backtab: pw_entry
            KeyNavigation.tab: session
        }

        Text {
            id: sessionTitle

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: login_button.bottom
            anchors.topMargin: 18

            text: "HYPRLAND"

            color: "#90ffffff"

            font.family: "JetBrains Mono"
            font.pixelSize: 12
            font.bold: true
            font.letterSpacing: 3
        }

        Row {
            id: buttonRow

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5

            spacing: 8

            Rectangle {
                id: system_button

                width: 90
                height: 34

                color: powerMouse.containsMouse
                       ? "#ccffffff"
                       : "#99000000"

                border.color: "#ffffff"
                border.width: 1
                radius: 5

                Text {
                    anchors.centerIn: parent

                    text: "POWER"

                    color: powerMouse.containsMouse
                           ? "#000000"
                           : "#ffffff"

                    font.family: "JetBrains Mono"
                    font.pixelSize: 11
                }

                MouseArea {
                    id: powerMouse

                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: sddm.powerOff()
                }

                KeyNavigation.backtab: session
                KeyNavigation.tab: reboot_button
            }

            Rectangle {
                id: reboot_button

                width: 90
                height: 34

                color: rebootMouse.containsMouse
                       ? "#ccffffff"
                       : "#99000000"

                border.color: "#ffffff"
                border.width: 1
                radius: 5

                Text {
                    anchors.centerIn: parent

                    text: "REBOOT"

                    color: rebootMouse.containsMouse
                           ? "#000000"
                           : "#ffffff"

                    font.family: "JetBrains Mono"
                    font.pixelSize: 11
                }

                MouseArea {
                    id: rebootMouse

                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: sddm.reboot()
                }

                KeyNavigation.backtab: system_button
                KeyNavigation.tab: suspend_button
            }

            Rectangle {
                id: suspend_button

                width: 90
                height: 34

                visible: sddm.canSuspend

                color: suspendMouse.containsMouse
                       ? "#ccffffff"
                       : "#99000000"

                border.color: "#ffffff"
                border.width: 1
                radius: 5

                Text {
                    anchors.centerIn: parent

                    text: "SLEEP"

                    color: suspendMouse.containsMouse
                           ? "#000000"
                           : "#ffffff"

                    font.family: "JetBrains Mono"
                    font.pixelSize: 11
                }

                MouseArea {
                    id: suspendMouse

                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: sddm.suspend()
                }

                KeyNavigation.backtab: reboot_button
                KeyNavigation.tab: session
            }
        }
    }
}

    Rectangle {
        id: actionBar
        anchors.top: parent.top;
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width; height: 40

        Row {
            anchors.left: parent.left
            anchors.margins: 5
            height: parent.height
            spacing: 5

            Text {
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                text: textConstants.session
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter
            }

            ComboBox {
                id: session
                width: 245
                anchors.verticalCenter: parent.verticalCenter

                arrowIcon: "angle-down.png"

                model: sessionModel
                index: sessionModel.lastIndex

                font.pixelSize: 14

                KeyNavigation.backtab: hibernate_button; KeyNavigation.tab: layoutBox
            }

            Text {
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                text: textConstants.layout
                font.pixelSize: 14
                verticalAlignment: Text.AlignVCenter
            }

            LayoutBox {
                id: layoutBox
                width: 90
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 14

                arrowIcon: "angle-down.png"

                KeyNavigation.backtab: session; KeyNavigation.tab: user_entry
            }
        }
    }

    Component.onCompleted: {
        if (user_entry.text === "")
            user_entry.focus = true
        else
            pw_entry.focus = true
    }
}
}
