Class {
	#name : #ChatRoom,
	#superclass : #Object,
	#instVars : [
		'members'
	],
	#category : #ProtoHackers
}

{ #category : #initialization }
ChatRoom >> initialize [
	members := Set new. 
]
