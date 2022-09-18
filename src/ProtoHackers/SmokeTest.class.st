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
	(listenSocket isValid) ifFalse: [ ^ false ].
	socket := listenSocket accept.
	self crTrace: 'Client connected'.
	[ [ self clientLoop: socket ] whileTrue ] fork.
	^true.
]

{ #category : #'private - helpers' }
SmokeTest >> clientLoop: aSocket [
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"	
			
	| data |
	aSocket isValid ifFalse: [ ^false ].
	data := aSocket receiveData.
	aSocket sendData: data.
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
	[ [ ^self acceptLoop ] whileTrue ] fork.
]

{ #category : #'start-stop' }
SmokeTest >> stop [
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"	
			
	| |
	listenSocket isValid ifTrue: [  listenSocket close. ].
]
