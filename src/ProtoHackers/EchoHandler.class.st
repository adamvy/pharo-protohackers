Class {
	#name : #EchoHandler,
	#superclass : #Object,
	#instVars : [
		'socket'
	],
	#category : #ProtoHackers
}

{ #category : #starting }
EchoHandler >> fork [
	'EchoHandler started' traceCr.
	[
		[ self loop ] whileTrue.
		'EchoHandler ended' traceCr.
	] fork.

]

{ #category : #behavior }
EchoHandler >> loop [
	| data |
	socket isConnected ifFalse: [ ^false ].
	data := socket receiveData.
	socket sendData: data.
	('Echoed {1} bytes.' format: { data size }) traceCr.
	^true.
]

{ #category : #accessing }
EchoHandler >> socket [

	^ socket
]

{ #category : #accessing }
EchoHandler >> socket: anObject [

	socket := anObject
]
