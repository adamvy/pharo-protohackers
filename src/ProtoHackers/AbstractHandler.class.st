Class {
	#name : #AbstractHandler,
	#superclass : #Object,
	#instVars : [
		'socket'
	],
	#category : #ProtoHackers
}

{ #category : #converting }
AbstractHandler class >> asServer [
	^self asServer: 8888
]

{ #category : #converting }
AbstractHandler class >> asServer: aPort [
	^Server onPort: aPort
		withHandler: [ :socket | (self for: socket) go ].
]

{ #category : #'instance creation' }
AbstractHandler class >> for: aSocket [
	^self new socket: aSocket ; yourself.
]

{ #category : #behavior }
AbstractHandler >> doWork [
	"template method"
	socket closeAndDestroy.
]

{ #category : #starting }
AbstractHandler >> go [
	Transcript << self className << ' started.' ; cr ; endEntry.
	[
		[
			socket isConnected ifFalse: [ ^self ].
			[ self doWork ]
				on: Error do: [ :e | e traceCr. ^self ].
		] repeat.
	] ensure: [ 
		Transcript << self className << ' ended.' ; cr ; endEntry.
		socket closeAndDestroy.
	].
]

{ #category : #accessing }
AbstractHandler >> socket [

	^ socket
]

{ #category : #accessing }
AbstractHandler >> socket: anObject [

	socket := anObject
]
