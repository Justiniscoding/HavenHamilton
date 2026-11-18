function messageToText(event: string, ...args: any[]): string {
	let text = event;

	for(let i = 0; i < args.length; i++){
		text += "\n" + args[i];
	}

	return text;
}

function emit(socket: Bun.ServerWebSocket<undefined>, event: string, ...args: any[]){
	socket.send(messageToText(event, ...args));
}

function publish(socket: Bun.ServerWebSocket<undefined>, group: string, event: string, ...args: any[]){
	socket.publish(group, messageToText(event, ...args));
}

Bun.serve({
	fetch(req, server) {
		server.upgrade(req)
	},
	port: 8080,
	websocket: {
		open(ws){
			console.log("connection received from websocket")
			ws.subscribe("findRooms");
		},
		message(ws, message){
			if(typeof message !== "string"){
				return;
			}

			const messageParts = message.split("\n");
			const type = messageParts[0];
			const args = messageParts.slice(1);

			if(type == "createRoom"){
				publish(ws, "findRooms", "createRoom", args[0]);
			}
		}
	}
});
