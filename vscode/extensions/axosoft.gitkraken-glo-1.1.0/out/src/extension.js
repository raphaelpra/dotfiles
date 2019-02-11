'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const config_1 = require("./config");
const DEBUG = false;
function debug(fn) {
    DEBUG && fn();
}
const APP_TITLE = 'Glo';
const OPEN_COMMAND = 'glo.open';
var MessageType;
(function (MessageType) {
    MessageType["GetState"] = "getState";
    MessageType["SetState"] = "setState";
    MessageType["OpenLink"] = "shell.openExternal";
})(MessageType || (MessageType = {}));
function activate(context) {
    const openGloCommand = vscode.commands.registerCommand(OPEN_COMMAND, () => createWebviewPanel(context));
    context.subscriptions.push(openGloCommand);
    const statusBarItem = vscode.window.createStatusBarItem();
    statusBarItem.text = APP_TITLE;
    statusBarItem.command = OPEN_COMMAND;
    statusBarItem.show();
    context.subscriptions.push(statusBarItem);
    debug(() => vscode.commands.executeCommand(OPEN_COMMAND));
}
exports.activate = activate;
function deactivate() { }
exports.deactivate = deactivate;
let _panel;
function createWebviewPanel(context) {
    if (_panel) {
        _panel.reveal();
        return;
    }
    _panel = vscode.window.createWebviewPanel('gitkraken-glo', APP_TITLE, vscode.ViewColumn.Active, {
        enableScripts: true,
        retainContextWhenHidden: true
    });
    _panel.webview.html = getWebviewContent();
    _panel.webview.onDidReceiveMessage((message) => {
        // localStorage is not available inside the webview so we add
        // support for messages to get/set data using the extension's storage.
        switch (message.type) {
            case MessageType.GetState:
                _panel.webview.postMessage({
                    from: 'extension',
                    type: 'sendState',
                    state: context.globalState.get('appState', {})
                });
                break;
            case MessageType.SetState:
                context.globalState.update('appState', message.args[0]);
                break;
            case MessageType.OpenLink:
                vscode.commands.executeCommand('vscode.open', vscode.Uri.parse(message.args[0]));
                break;
        }
    });
    _panel.onDidDispose(() => {
        _panel = null;
    });
    debug(() => setTimeout(() => vscode.commands.executeCommand('workbench.action.webview.openDeveloperTools'), 1000));
}
function getWebviewContent() {
    const appUrlWithSlash = config_1.default.appUrl + (config_1.default.appUrl.endsWith('/') ? '' : '/');
    return `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>${APP_TITLE}</title>
            <style>
                body {
                    padding: 0;
                    margin: 0;
                    position: absolute;
                    top: 0;
                    bottom: 0;
                    left: 0;
                    right: 0;
                }

                iframe {
                    height: 100%;
                    width: 100%;
                    border: none;
                }
            </style>
            <script>
                var vscode = acquireVsCodeApi();

                window.addEventListener('message', (event) => {
                    if (event.data.from === 'iframe') {
                        vscode.postMessage(event.data);
                    } else if (event.data.from === 'extension') {
                        document.querySelector('iframe').contentWindow.postMessage(event.data, '*');
                    }
                });
            </script>
        </head>
        <body>
            <iframe src="${appUrlWithSlash}" />
        </body>
        </html>
    `;
}
//# sourceMappingURL=extension.js.map