Class {
	#name : #SmokeTest,
	#superclass : #Object,
	#instVars : [
		'listenSocket',
		'port'
	],
	#category : #ProtoHackers
}

{ #category : #'private - helpers' }
SmokeTest >> acceptLoop [
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"	
			
	| socket |
	listenSocket isValid ifFalse: [ ^false ].
	self crTrace: 'Waiting for client to connect.'.
	socket := listenSocket waitForAcceptFor: 30s.
	socket ifNil: [ 
		self crTrace: 'No client connected yet, looping'.
		^true
	].
	self crTrace: 'Client connected'.
	[ [ self clientLoop: socket ] whileTrue ] fork.
	^true.
]

{ #category : #'private - helpers' }
SmokeTest >> clientLoop: aSocket [
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"	
	| data |
	aSocket isConnected ifFalse: [
		'Client disconnected' traceCr.
		^false
	].
	data := aSocket receiveData.
	aSocket sendData: data.
	('Echoed back {1}' format: { data size }) traceCr.
	^true.
]

{ #category : #accessing }
SmokeTest >> port [

	^ port
]

{ #category : #accessing }
SmokeTest >> port: anObject [

	port := anObject
]

{ #category : #'start-stop' }
SmokeTest >> start [
	"start the server"	
	|  |
	listenSocket := Socket newTCP.
	listenSocket listenOn: port backlogSize: 10.
	self crTrace: ('Listening on {1}' format: { port }).
	[
		[ self acceptLoop ] whileTrue.
		self crTrace: 'Terminated'.
	] fork.
]

{ #category : #'start-stop' }
SmokeTest >> stop [
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"	
			
	| |
	listenSocket isValid ifTrue: [ listenSocket closeAndDestroy ]
]
