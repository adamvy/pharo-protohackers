Class {
	#name : #AbstractHandler,
	#superclass : #Object,
	#instVars : [
		'socket'
	],
	#category : #ProtoHackers
}

{ #category : #'instance creation' }
AbstractHandler class >> for: aSocket [
	^self basicNew initialize socket: aSocket
]

{ #category : #behavior }
AbstractHandler >> doWork [
	"template method"
	^true
]

{ #category : #starting }
AbstractHandler >> fork [
	('{1} started' format: { self className }) traceCr.
	[
		[ [ self loop ] whileTrue. ]
			ensure: [
				('{1} ended' format: { self className }) traceCr.
				socket closeAndDestroy.
			]
	] forkNamed: ('ProtoHackers Client Handler Loop: {1}' format: self className)

]

{ #category : #behavior }
AbstractHandler >> loop [
	socket isConnected ifFalse: [ ^false ].
	^[ self doWork ] on: Error
		do: [ :e |
			e traceCr.
			false. ]
]

{ #category : #accessing }
AbstractHandler >> socket [

	^ socket
]

{ #category : #accessing }
AbstractHandler >> socket: anObject [

	socket := anObject
]
