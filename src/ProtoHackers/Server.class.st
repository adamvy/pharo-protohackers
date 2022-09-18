Class {
	#name : #Server,
	#superclass : #Object,
	#instVars : [
		'port',
		'process',
		'listenSocket',
		'handlerClass'
	],
	#category : #ProtoHackers
}

{ #category : #'private - helpers' }
Server >> ensureListener [
	(listenSocket isNotNil and: [ listenSocket isValid ]) ifTrue: [ ^ self ].
	listenSocket := Socket newTCP.
	listenSocket listenOn: port backlogSize: 10
]

{ #category : #accessing }
Server >> handlerClass [

	^ handlerClass
]

{ #category : #accessing }
Server >> handlerClass: anObject [

	handlerClass := anObject
]

{ #category : #accessing }
Server >> isRunning [
	^process isNotNil.
]

{ #category : #'private - helpers' }
Server >> listenLoop [
	| client handler |
	self isRunning ifFalse: [ ^false ].
	self ensureListener.
	'Waiting for client for 30s' traceCr.
	client := listenSocket waitForAcceptFor: 30.
	client ifNil: [ ^ true ].
	('Client connected from: {1}' format: { client remoteAddress }) traceCr.
	handler := handlerClass new.
	handler socket: client.
	handler fork.
	^true.
]

{ #category : #accessing }
Server >> port [

	^ port
]

{ #category : #accessing }
Server >> port: anObject [

	port := anObject
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
		[ self listenLoop ] whileTrue.
		'Listener process terminated' traceCr.
		process := nil.
	] forkNamed: 'Proto Hackers Listen Process'

]

{ #category : #'start-stop' }
Server >> stop [
	self isRunning ifFalse: [ ^self ].
	listenSocket ifNotNil: [ listenSocket closeAndDestroy ].
	process terminate.
	process := nil.
]
