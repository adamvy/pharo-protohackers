Class {
	#name : #AssetPrice,
	#superclass : #Object,
	#instVars : [
		'timestamp',
		'price'
	],
	#category : #ProtoHackers
}

{ #category : #accessing }
AssetPrice >> price [

	^ price
]

{ #category : #accessing }
AssetPrice >> price: anObject [

	price := anObject
]

{ #category : #accessing }
AssetPrice >> timestamp [

	^ timestamp
]

{ #category : #accessing }
AssetPrice >> timestamp: anObject [

	timestamp := anObject
]
