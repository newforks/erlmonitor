

document.write("<script type='text/javascript' src='https://cdn.socket.io/socket.io-1.2.0.js'></script>");

var HostPort = 'http://127.0.0.1:8080/websokcet';
var socket =  io.connect(HostPort);
socket.on('connect', function() {
    console.log("connected");
});
socket.on('message', function(data) {
    console.log("data:" + data);
});
socket.on('disconnect', function() {
    console.log("disconnect");
});
socket.on('chat message', function(msg){
    console.log("chat message")
});
function sendMessage() {
    var userName = "username";
    var message = "message~";

    var jsonObject = {
        userName: userName,
        message: message
    };
    socket.json.send(jsonObject);

    // socket.emit('emit message';
}
