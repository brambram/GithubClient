import QtQuick 2.0
import QtWebKit 3.0
import QtWebKit.experimental 1.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Extras.Browser 0.1
import Ubuntu.Components.Popups 0.1

WebView {
    id: _webview

    signal newTabRequested(url url)

    property real devicePixelRatio: 1.0
    onDevicePixelRatioChanged: {
        // Do not make this patch to QtWebKit a hard requirement.
        if (experimental.hasOwnProperty('devicePixelRatio')) {
            experimental.devicePixelRatio = devicePixelRatio
        }
    }

    interactive: !selection.visible
    maximumFlickVelocity: height * 5

    property real scale: experimental.test.contentsScale * experimental.test.devicePixelRatio

    UserAgent {
        id: userAgent
    }
    experimental.userAgent: userAgent.defaultUA
    onNavigationRequested: {
        _webview.experimental.userAgent = userAgent.getUAString(request.url)
        request.action = WebView.AcceptRequest
    }

    experimental.preferences.navigatorQtObjectEnabled: true
    experimental.userScripts: [Qt.resolvedUrl("hyperlinks.js"),
                               Qt.resolvedUrl("selection.js")]
    experimental.onMessageReceived: {
        var data = null
        try {
            data = JSON.parse(message.data)
        } catch (error) {
            console.debug('DEBUG:', message.data)
            return
        }
        if ('event' in data) {
            if ((data.event === 'longpress') || (data.event === 'selectionadjusted')) {
                selection.clearData()
                selection.createData()
                if ('html' in data) {
                    selection.mimedata.html = data.html
                }
                // FIXME: push the text and image data in the order
                // they appear in the selected block.
                if ('text' in data) {
                    selection.mimedata.text = data.text
                }
                if ('images' in data) {
                    // TODO: download and cache the images locally
                    // (grab them from the webview’s cache, if possible),
                    // and forward local URLs.
                    selection.mimedata.urls = data.images
                }
                selection.show(data.left * scale, data.top * scale,
                               data.width * scale, data.height * scale)
            } else if (data.event === 'newtab') {
                newTabRequested(data.url)
            }
        }
    }

    experimental.itemSelector: ItemSelector {}

    property alias selection: selection
    property ActionList selectionActions
    Selection {
        id: selection

        anchors.fill: parent
        visible: false

        property Item __popover: null
        property var mimedata: null

        Component {
            id: selectionPopover
            ActionSelectionPopover {
                grabDismissAreaEvents: false
                actions: selectionActions
            }
        }

        function createData() {
            if (mimedata === null) {
                mimedata = Clipboard.newData()
            }
        }

        function clearData() {
            if (mimedata !== null) {
                delete mimedata
                mimedata = null
            }
        }

        function actionTriggered() {
            selection.visible = false
        }

        function __showPopover() {
            __popover = PopupUtils.open(selectionPopover, selection.rect)
            var actions = __popover.actions.actions
            for (var i in actions) {
                actions[i].onTriggered.connect(actionTriggered)
            }
        }

        function show(x, y, width, height) {
            rect.x = x
            rect.y = y
            rect.width = width
            rect.height = height
            visible = true
            __showPopover()
        }

        onVisibleChanged: {
            if (!visible && (__popover != null)) {
                PopupUtils.close(__popover)
                __popover = null
            }
        }

        onResized: {
            var message = new Object
            message.query = 'adjustselection'
            var rect = selection.rect
            var scale = _webview.scale
            message.left = rect.x / scale
            message.right = (rect.x + rect.width) / scale
            message.top = rect.y / scale
            message.bottom = (rect.y + rect.height) / scale
            _webview.experimental.postMessage(JSON.stringify(message))
        }

        function share() {
            console.log("TODO: share selection")
        }

        function save() {
            console.log("TODO: save selection")
        }

        function copy() {
            Clipboard.push(mimedata)
            clearData()
        }
    }

    Scrollbar {
        parent: _webview.parent
        flickableItem: _webview
        align: Qt.AlignTrailing
    }

    Scrollbar {
        parent: _webview.parent
        flickableItem: _webview
        align: Qt.AlignBottom
    }

    WebviewThumbnailer {
        id: thumbnailer
        webview: _webview
        targetSize: Qt.size(units.gu(12), units.gu(12))
        property url thumbnailSource: "image://webthumbnail/" + _webview.url
        onThumbnailRendered: {
            if (url == _webview.url) {
                _webview.thumbnail = thumbnailer.thumbnailSource
            }
        }
    }
    property url thumbnail: (url && thumbnailer.thumbnailExists()) ? thumbnailer.thumbnailSource : ""
    onLoadingChanged: {
        if (loadRequest.status === WebView.LoadSucceededStatus) {
            if (!thumbnailer.thumbnailExists()) {
                thumbnailer.renderThumbnail()
            }
        }
    }
}
