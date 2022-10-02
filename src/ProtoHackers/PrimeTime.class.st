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
	^self basicNew initialize stream: (SocketStream on: aSocket)
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
		stream nextPut: (Character lf).
	] on: Error do: [ :e |
		stream nextPut: 'Error\n'.
	].
	stream flush.
	^true
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
