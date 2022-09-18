Class {
	#name : #SmokeTest,
	#superclass : #Object,
	#instVars : [
		'listenSocket'
	],
	#category : #ProtoHackers
}

{ #category : #visiting }
SmokeTest >> acceptClient: aListener [
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"	
			
	| client |
	client := aListener accept.
	('Client connected: {1}' format: {client}) traceCr.
	[ [ self clientLoop: client ] repeat ] fork.

]

{ #category : #'private - helpers' }
SmokeTest >> clientLoop: aSocket [
	| data |
	data := aSocket receiveData.
	aSocket sendData: data.
	self crTrace: ('Echoed {1} bytes' format: { data size. })

]

{ #category : #accessing }
SmokeTest >> start: aPort [
	"start the server"	
	| socket |
	socket := Socket newTCP.
	socket listenOn: aPort backlogSize: 10.
	self crTrace: ('Listening on {1}' format: { aPort }).
	[ [ self acceptClient: socket ] repeat. ] fork.
]
