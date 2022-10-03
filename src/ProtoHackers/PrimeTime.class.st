Class {
	#name : #PrimeTime,
	#superclass : #AbstractHandler,
	#instVars : [
		'stream'
	],
	#category : #ProtoHackers
}

{ #category : #'instance creation' }
PrimeTime class >> for: aSocket [
	^(self new) socket: aSocket ; stream: (SocketStream on: aSocket) ; yourself
]

{ #category : #behavior }
PrimeTime >> doWork [
	| line |
	line := stream nextLineLf.
	[
		| response command |
		command := STONJSON fromString: line.
		response := self handleCommand: command.
		STONJSON put: response onStream: stream.
	] on: Error do: [ :e |
		stream nextPutAll: 'Error'.
	].
	stream nextPut: (Character lf) ; flush.
]

{ #category : #behavior }
PrimeTime >> handleCommand: command [
	| number |
	number := command at: 'number'.
	(command at: 'method') = 'isPrime' ifTrue: [
		^Dictionary new
			at: 'method' put: 'isPrime' ;
			at: 'prime' put: (number isPrime) ;
			yourself.
	] ifFalse: [
		^Error new signal: 'invalid command'
	].

]

{ #category : #accessing }
PrimeTime >> stream [

	^ stream
]

{ #category : #accessing }
PrimeTime >> stream: anObject [

	^ stream := anObject
]
