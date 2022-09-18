Class {
	#name : #AbstractHandler,
	#superclass : #Object,
	#instVars : [
		'socket'
	],
	#category : #ProtoHackers
}

{ #category : #behavior }
AbstractHandler >> doWork [
	"template method"
	^true
]

{ #category : #starting }
AbstractHandler >> fork [
	'EchoHandler started' traceCr.
	[
		[ self loop ] whileTrue.
		'EchoHandler ended' traceCr.
	] forkNamed: ('ProtoHackers Client Handler Loop: {1}' format: self className)

]

{ #category : #behavior }
AbstractHandler >> loop [
	socket isConnected ifFalse: [ ^false ].
	^self doWork.
]

{ #category : #accessing }
AbstractHandler >> socket [

	^ socket
]

{ #category : #accessing }
AbstractHandler >> socket: anObject [

	socket := anObject
]
