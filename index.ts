Bun.serve({
	fetch(req, server) {
		server.upgrade(req)
	},
	port: 8080,
	websocket: {
		open(ws){
			console.log("connection received from " + ws)
			ws.send("test!")
		},
		message(ws, message){
			console.log(`Received message from ${ws}, it says "${message}"`);
		}
	}
});
