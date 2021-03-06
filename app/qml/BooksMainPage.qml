/*
  Copyright (C) 2015-2020 Jolla Ltd.
  Copyright (C) 2015-2020 Slava Monich <slava.monich@jolla.com>

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met:

    1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer
       in the documentation and/or other materials provided with the
       distribution.
    3. Neither the names of the copyright holders nor the names of its
       contributors may be used to endorse or promote products derived
       from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
  THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.books 1.0

Page {
    id: root

    allowedOrientations: window.allowedOrientations

    //property variant shelf
    property variant currentShelf: storageView.currentShelf

    property Item _bookView

    function createBookViewIfNeeded() {
        if (Settings.currentBook && !_bookView) {
            _bookView = bookViewComponent.createObject(root)
        }
    }

    Connections {
        target: Settings
        onCurrentBookChanged: createBookViewIfNeeded()
    }

    Component {
        id: bookViewComponent
        BooksBookView {
            anchors.fill: parent
            opacity: book ? 1 : 0
            visible: opacity > 0
            orientation: root.orientation
            pageActive: root.status === PageStatus.Active
            book: Settings.currentBook ? Settings.currentBook : null
            onCloseBook: Settings.currentBook = null
            Behavior on opacity { FadeAnimation {} }
        }
    }

    BooksStorageView {
        id: storageView
        anchors.fill: parent
        opacity: Settings.currentBook ? 0 : 1
        visible: opacity > 0
        Behavior on opacity { FadeAnimation {} }
        onOpenBook: Settings.currentBook = book
    }

    Component.onCompleted: createBookViewIfNeeded()
}
