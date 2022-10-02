Class {
	#name : #MeansToAnEndTest,
	#superclass : #Object,
	#category : #ProtoHackers
}

{ #category : #'instance creation' }
MeansToAnEndTest class >> on: aPort [
	| server |
	server := Server new.
	server port: aPort.
	server handlerClass: MeansToAnEndHandler.
	server start.

]
