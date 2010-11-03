//
//  ConceptObjectConnections.h
//  ConceptMap
//
//  Created by Preston Rohner on 10/9/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "ConceptObjectConnection.h"

@class Concept;
@class ConceptObject;


@interface ConceptObjectConnections : CAShapeLayer {
	NSMutableDictionary *connections;
}

- (void)addConnectionFrom:(ConceptObject *)src to:(ConceptObject *)dst with:(NSString *)description;
- (void)removeConnectionFrom:(ConceptObject *)src to:(ConceptObject *)dst;
- (void)removeConnectionsToAndFrom:(ConceptObject *)conceptObject;

@end
