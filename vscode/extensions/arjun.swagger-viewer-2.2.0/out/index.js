"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const PreviewClient = require("./preview/client");
const LanguageClient = require("./language/client");
function activate(context) {
    PreviewClient.activate(context);
    LanguageClient.activate(context);
}
exports.activate = activate;
function deactivate() {
    PreviewClient.deactivate();
    LanguageClient.deactivate();
}
exports.deactivate = deactivate;
//# sourceMappingURL=index.js.map