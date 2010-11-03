//
//  ConceptObjectConnection.h
//  ConceptMap
//
//  Created by Preston Rohner on 10/10/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ConceptObject;

@interface ConceptObjectConnection : NSObject {
	ConceptObject *src;
	ConceptObject *dst;
	NSString *connectionDescription;
}

@property (nonatomic, retain) ConceptObject *src;
@property (nonatomic, retain) ConceptObject *dst;
@property (nonatomic, retain) NSString *connectionDescription;
@property (nonatomic, readonly) NSString *keyString;

@end
