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

import QtQuick 2.0
import QtWayland.Compositor 1.0
import QtQml 2.2

WaylandCompositor {
    id: sddmCompositor

    onSurfaceRequested: {
        var surface = surfaceComponent.createObject(sddmCompositor, {});
        surface.initialize(sddmCompositor, client, id, version);
    }

    Instantiator {
        id: screens
        model: Qt.application.screens

        delegate: Screen {
            compositor: sddmCompositor
            Component.onCompleted: if (!sddmCompositor.defaultOutput) sddmCompositor.defaultOutput = this
        }
    }

    Component {
        id: surfaceComponent
        WaylandSurface {}
    }

    Component {
        id: chromeComponent
        Chrome {}
    }

    QtWindowManager {
        showIsFullScreen: true
    }

    WlShell {
        onWlShellSurfaceCreated: handleShellSurfaceCreated(shellSurface)
    }

    XdgShellV5 {
        onXdgSurfaceCreated: handleShellSurfaceCreated(xdgSurface)
        onXdgPopupCreated: handleShellSurfaceCreated(xdgPopup)
    }

    function createShellSurfaceItem(shellSurface, output) {
        var parentSurfaceItem = output.viewsBySurface[shellSurface.parentSurface];
        var parent = parentSurfaceItem || output.surfaceArea;
        var item = chromeComponent.createObject(parent, {"shellSurface": shellSurface, "output": output});
        if (parentSurfaceItem) {
            item.x += output.position.x;
            item.y += output.position.y;
        }
        output.viewsBySurface[shellSurface.surface] = item;
    }

    function handleShellSurfaceCreated(shellSurface) {
        for (var i = 0; i < screens.count; ++i)
            createShellSurfaceItem(shellSurface, screens.objectAt(i));
    }
}
