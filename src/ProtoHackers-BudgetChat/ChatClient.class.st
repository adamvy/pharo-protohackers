Class {
	#name : #ChatClient,
	#superclass : #Object,
	#instVars : [
		'socket',
		'stream',
		'server',
		'handler',
		'name'
	],
	#category : #'ProtoHackers-BudgetChat'
}

{ #category : #'instance creation' }
ChatClient class >> forSocket: aSocket onServer: server [
	| stream |
	stream := SocketStream on: aSocket.
	stream noTimeout.
	^self new socket: aSocket ; stream: stream ; server: server ; yourself.
]

{ #category : #behavior }
ChatClient >> announceJoin: aClient [
	stream << '* ' << aClient name << ' has entered the room'.
	stream nextPut: (Character lf) ; flush.
	
]

{ #category : #behavior }
ChatClient >> announceLeave: aClient [
	stream << '* ' << aClient name << ' has left the room'.
	stream nextPut: (Character lf) ; flush.
]

{ #category : #compatibility }
ChatClient >> doMessage: aLine [
	server message: aLine from: self.
]

{ #category : #behavior }
ChatClient >> doRegistration: aName [
	name := aName.
	self server register: self.
	handler := ChatMessageHandler new context: self ; yourself.
]

{ #category : #behavior }
ChatClient >> doWelcome [
	stream << 'Welcome to basic chat, what shall we call you?'.
	stream nextPut: (Character lf) ; flush.
]

{ #category : #behavior }
ChatClient >> doWork [
	| line |
	line := stream nextLineLf.
	self handle: line.
]

{ #category : #'start-stop' }
ChatClient >> fork [

	[ 
	[ 
	handler onConnect.
	[ [ socket isConnected ] whileTrue: [ self doWork ] ]
		on: Error
		do: [ :e | e traceCr ] ] ensure: [ 
		socket closeAndDestroy.
		server unregister: self ] ] forkNamed:
		('Chat Client for {1}' format: socket remoteAddress printString)
]

{ #category : #behavior }
ChatClient >> handle: aLine [
	handler handle: aLine.
	
]

{ #category : #accessing }
ChatClient >> handler [

	^ handler
]

{ #category : #accessing }
ChatClient >> handler: anObject [

	handler := anObject
]

{ #category : #initialization }
ChatClient >> initialize [ 
	handler := ChatRegistrationHandler new context: self ; yourself.
]

{ #category : #behavior }
ChatClient >> members: clients [
	stream << '* The room contains: '.
	stream << ((clients select: [ :c | c ~~ self ] thenCollect: [ :c | c name ]) asCommaString).
	stream nextPut: (Character lf) ; flush.
]

{ #category : #behavior }
ChatClient >> message: aMessage from: aClient [
	stream << '[' << aClient name << '] ' << aMessage.
	stream nextPut: (Character lf) ; flush.
	
]

{ #category : #accessing }
ChatClient >> name [

	^ name
]

{ #category : #accessing }
ChatClient >> name: anObject [

	name := anObject
]

{ #category : #accessing }
ChatClient >> server [

	^ server
]

{ #category : #accessing }
ChatClient >> server: anObject [

	server := anObject
]

{ #category : #accessing }
ChatClient >> socket [

	^ socket
]

{ #category : #accessing }
ChatClient >> socket: anObject [

	socket := anObject
]

{ #category : #'start-stop' }
ChatClient >> stop [
	socket closeAndDestroy.
	
]

{ #category : #accessing }
ChatClient >> stream [

	^ stream
]

{ #category : #accessing }
ChatClient >> stream: anObject [

	stream := anObject
]
