Class {
	#name : #EchoProcess,
	#superclass : #Object,
	#instVars : [
		'socket',
		'client'
	],
	#category : #ProtoHackers
}

{ #category : #accessing }
EchoProcess >> client [

	^ client
]

{ #category : #accessing }
EchoProcess >> client: anObject [

	client := anObject
]

{ #category : #private }
EchoProcess >> fork [
	| |
	[ [ self loop ] repeat ] fork.

]

{ #category : #'as yet unclassified' }
EchoProcess >> loop [
	| data |
	data := client receiveData.
	client sendData: data.
]
