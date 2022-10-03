Class {
	#name : #EchoHandler,
	#superclass : #AbstractHandler,
	#category : #ProtoHackers
}

{ #category : #behavior }
EchoHandler >> doWork [
	| data |
	data := socket receiveData.
	socket sendData: data.
	Transcript << 'Echoed ' << data size printString << ' bytes' ; cr ; endEntry.
]
