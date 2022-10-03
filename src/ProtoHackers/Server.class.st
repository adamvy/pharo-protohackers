Class {
	#name : #Server,
	#superclass : #Object,
	#instVars : [
		'port',
		'process',
		'listenSocket',
		'onConnected'
	],
	#category : #ProtoHackers
}

{ #category : #'instance creation' }
Server class >> onPort: aPort withHandler: aBlock [
	^self new port: aPort ; onConnected: aBlock ; start ; yourself.
]

{ #category : #'private - helpers' }
Server >> ensureListener [
	(listenSocket isNotNil and: [ listenSocket isValid ]) ifTrue: [ ^ self ].
	listenSocket := Socket newTCP.
	listenSocket listenOn: port backlogSize: 10 interface: (SocketAddress fromDottedString: '0.0.0.0')
]

{ #category : #accessing }
Server >> isRunning [
	^process isNotNil.
]

{ #category : #'private - helpers' }
Server >> listenLoop [
	| client |
	self isRunning ifFalse: [ ^ false ].
	self ensureListener.
	client := listenSocket waitForAcceptFor: 30.
	client ifNil: [ ^ true ].
	Transcript << ('Client connected from {1}' format: {client remoteAddress printString}) ; cr ; endEntry.
	(onConnected newProcessWith: {client}) name: 'ProtoHackers handler' ; resume.
	^ true
]

{ #category : #accessing }
Server >> listenSocket [

	^ listenSocket
]

{ #category : #accessing }
Server >> listenSocket: anObject [

	listenSocket := anObject
]

{ #category : #accessing }
Server >> onConnected [

	^ onConnected
]

{ #category : #accessing }
Server >> onConnected: anObject [

	onConnected := anObject
]

{ #category : #accessing }
Server >> port [

	^ port
]

{ #category : #accessing }
Server >> port: anObject [

	port := anObject
]

{ #category : #accessing }
Server >> process [

	^ process
]

{ #category : #accessing }
Server >> process: anObject [

	process := anObject
]

{ #category : #'start-stop' }
Server >> start [ 
	"start the server process and begin accepting clients"
	self isRunning ifTrue: [ ^self ].
	port isNumber ifFalse: [ 
		self error: 'Port must be a number'
	].
	process := [ 
		('Server started on port: {1}' format: { port }) traceCr.
		[
			[ self listenLoop ] whileTrue.
		] ensure: [
			listenSocket closeAndDestroy.
			process := nil.
			'Listener process terminated' traceCr.
		]
	] forkNamed: 'Proto Hackers Listen Process'

]

{ #category : #'start-stop' }
Server >> stop [
	self isRunning ifFalse: [ ^self ].
	listenSocket ifNotNil: [ listenSocket closeAndDestroy ].
	process terminate.
	process := nil.
]
