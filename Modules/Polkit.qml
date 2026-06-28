import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Services.Polkit
import qs.Commons
import qs.Components

Scope {
    id: root

    PolkitAgent {
        id: agent
    }

    LazyLoader {
        active: agent.isActive

        component: PanelWindow {
            id: window
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            color: "#77000000"
            focusable: true
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            ColumnLayout {
                anchors.fill: parent

                Rectangle {
                    id: container
                    border {
                        width: 2
                        color: Color.mOutline
                    }
                    implicitWidth: 420
                    implicitHeight: content.implicitHeight + 40
                    Layout.alignment: Qt.Alignment.AlignHCenter
                    color: Color.mSurfaceHigh
                    radius: 10

                    RowLayout {
                        id: content
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 16

                        IconImage {
                            source: Quickshell.iconPath("lock")
                            implicitSize: 54
                            Layout.alignment: Qt.AlignTop
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 25

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                StyledText {
                                    Layout.fillWidth: true
                                    text: "Autenticación requerida"
                                    font.bold: true
                                    font.pointSize: Style.fontSize + 4
                                }

                                StyledText {
                                    Layout.fillWidth: true
                                    text: agent.flow?.message ?? ""
                                    wrapMode: Text.WordWrap
                                }
                            }

                            TextField {
                                id: passwordField
                                Layout.fillWidth: true
                                focus: true

                                visible: agent.flow?.isResponseRequired ?? false
                                echoMode: (agent.flow?.responseVisible ?? false) ? TextInput.Normal : TextInput.Password

                                padding: 10
                                font.family: Style.fontFamily
                                font.pointSize: Style.fontSize + 2
                                font.letterSpacing: 4
                                color: Color.mOnSurface

                                background: Rectangle {
                                    color: Color.mSurfaceHighest
                                    border.color: passwordField.activeFocus ? Color.mPrimary : Color.mOutline
                                    radius: 8
                                }

                                onActiveFocusChanged: {
                                    if (!focus)
                                        forceActiveFocus();
                                }

                                Keys.onPressed: event => {
                                    if (event.key === Qt.Key_Escape) {
                                        agent.flow?.cancelAuthenticationRequest();
                                        event.accepted = true;
                                    }
                                }
                                onAccepted: {
                                    agent.flow?.submit(text);
                                    text = "";
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 10

                                Item {
                                    Layout.fillWidth: true
                                }

                                StyledButton {
                                    text: "Cancelar"
                                    onClicked: agent.flow?.cancelAuthenticationRequest()
                                }

                                StyledButton {
                                    text: "Confirmar"
                                    bgColor: Color.mPrimary

                                    onClicked: {
                                        agent.flow?.submit(passwordField.text);
                                        passwordField.text = "";
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
