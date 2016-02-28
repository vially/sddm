/***************************************************************************
* Copyright (c) 2016 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the
* Free Software Foundation, Inc.,
* 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
***************************************************************************/

import QtQuick 2.5
import QtQuick.Window 2.2
import QtWayland.Compositor 1.0

WaylandOutput {
    id: output
    property alias surfaceArea: background
    sizeFollowsWindow: false

    window: Window {
        id: win
        width: 1024
        height: 768
        visible: false

        Shortcut {
            sequence: "Ctrl+Alt+Backspace"
            onActivated: Qt.quit()
        }

        WaylandMouseTracker {
            id: mouseTracker
            anchors.fill: parent
            windowSystemCursorEnabled: true

            Rectangle {
                id: background
                anchors.fill: parent
                color: "black"
            }
        }
    }
}
