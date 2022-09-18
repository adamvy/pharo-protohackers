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
	('Echoed {1} bytes.' format: { data size }) traceCr.
	^true.
]
