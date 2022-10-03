Class {
	#name : #ChatServer,
	#superclass : #Object,
	#instVars : [
		'listener',
		'port',
		'room',
		'listenAddress',
		'process'
	],
	#category : #ProtoHackers
}

{ #category : #'instance creation' }
ChatServer class >> on: aPort [
	^self new port: aPort ; start ; yourself.
]

{ #category : #initialization }
ChatServer >> initialize [
	
]

{ #category : #accessing }
ChatServer >> listener [

	^ listener
]

{ #category : #accessing }
ChatServer >> listener: anObject [

	listener := anObject
]

{ #category : #accessing }
ChatServer >> port [

	^ port
]

{ #category : #accessing }
ChatServer >> port: anObject [

	port := anObject
]

{ #category : #accessing }
ChatServer >> room [

	^ room
]

{ #category : #accessing }
ChatServer >> room: anObject [

	room := anObject
]

{ #category : #'start-stop' }
ChatServer >> start [
	self stop.
	listener := Socket newTCP listenOn: self port backlogSize: 10 interface: listenAddress ; yourself.
	process := [ 
		| socket |
		socket := listener waitForConnectionFor: 30s.
		socket ifNotNil: [ self onConnection: socket. ]
	] newProcess.
	process resume
]

{ #category : #'start-stop' }
ChatServer >> stop [
	listener ifNotNil: [ 
		listener closeAndDestroy.
		listener := nil
	]

]
