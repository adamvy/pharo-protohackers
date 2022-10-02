Class {
	#name : #MeansToAnEndHandler,
	#superclass : #AbstractHandler,
	#instVars : [
		'buffer',
		'index',
		'prices'
	],
	#category : #ProtoHackers
}

{ #category : #behavior }
MeansToAnEndHandler >> doWork [
	| bytesRead |
	bytesRead := socket receiveDataInto: buffer startingAt: index.
	index := index + bytesRead.
	index == 10 ifTrue: [
		| type arg1 arg2 |
		type := (buffer byteAt: 1) asCharacter.
		arg1 := buffer longAt: 2 bigEndian: true.
		arg2 := buffer longAt: 6 bigEndian: true.
		type = $I
			ifTrue: [
				Transcript << ('Adding price at {1} price of {2}' format: { arg2 . arg1 }) ; cr ; endEntry.
				prices add: (AssetPrice new timestamp: arg1 ; price: arg2 ; yourself )
			].
		type = $Q
			ifTrue: [
				Transcript << ('Query from {1} to {2}' format: { arg1 . arg2 }) ; cr ; endEntry.
				self queryFrom: arg1 to: arg2.
			].
		index := 1.
	].
   ^true.
]

{ #category : #initialization }
MeansToAnEndHandler >> initialize [
	super initialize.
	buffer := ByteArray new: 9.
	index := 1.
	prices := SortedCollection sortBlock: [ :a :b | a timestamp < b timestamp ].
]

{ #category : #behavior }
MeansToAnEndHandler >> queryFrom: from to: to [
	| start end avg result |
	start := prices findBinaryIndex: [ :e | from - (e timestamp) ] ifNone: [ :a :b | b ].
	end := prices findBinaryIndex: [ :e | to - (e timestamp) ] ifNone: [ :a :b | a ].
				
	avg := start <= end
		ifTrue: [ ((prices collect: [ :e | e price ] from: start to: end) averageIfEmpty: 0) asInteger ]
		ifFalse: [ 0 ].
								
	result := ByteArray new: 4.
	result longAt: 1 put: avg bigEndian: true.
	socket sendData: result.
]
