Class {
	#name : #PrimeTime,
	#superclass : #AbstractHandler,
	#instVars : [
		'stream'
	],
	#category : #ProtoHackers
}

{ #category : #behavior }
PrimeTime >> doWork [
	| line |
	stream ifNil: [ 
		stream := SocketStream on: socket
	].

	line := stream nextLineLf.

]
