"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const fs = require("fs");
const vscode = require("vscode");
const express = require("express");
const http = require("http");
const socketio = require("socket.io");
const SERVER_HOST = vscode.workspace.getConfiguration('swaggerViewer').defaultHost || 'localhost';
const SERVER_PORT = vscode.workspace.getConfiguration('swaggerViewer').defaultPort || 9000;
const FILE_CONTENT = {};
class PreviewServer {
    constructor() {
        this.currentHost = SERVER_HOST;
        this.currentPort = SERVER_PORT;
        const app = express();
        app.use(express.static(path.join(__dirname, '..', '..', 'static')));
        app.use('/node_modules', express.static(path.join(__dirname, '..', '..', 'node_modules')));
        app.use('/:fileHash', (req, res) => {
            let htmlContent = fs.readFileSync(path.join(__dirname, '..', '..', 'static', 'index.html')).toString('utf-8').replace('%FILE_HASH%', req.params.fileHash);
            res.setHeader('Content-Type', 'text/html');
            res.send(htmlContent);
        });
        this.server = http.createServer(app);
        this.io = socketio(this.server);
        app.set('port', SERVER_PORT);
        this.startServer(this.currentPort);
        this.io.on('connection', (socket) => {
            socket.on("GET_INITIAL", function (data, fn) {
                let fileHash = data.fileHash;
                socket.join(fileHash);
                fn(FILE_CONTENT[fileHash]);
            });
        });
    }
    startServer(port) {
        this.currentPort = port;
        try {
            this.server
                .once('error', (e) => {
                if (e.code === 'EADDRINUSE') {
                    this.startServer(this.currentPort + 1);
                }
            })
                .listen(this.currentPort, err => {
                if (err)
                    this.startServer(this.currentPort + 1);
            });
        }
        catch (err) {
            this.startServer(this.currentPort + 1);
        }
    }
    update(fileHash, content) {
        FILE_CONTENT[fileHash] = content;
        this.io.to(fileHash).emit('TEXT_UPDATE', content);
    }
    getUrl(fileHash) {
        return `http://${this.currentHost}:${this.currentPort}/${fileHash}`;
    }
    stop() {
        this.server.close();
    }
}
exports.PreviewServer = PreviewServer;
//# sourceMappingURL=server.js.map