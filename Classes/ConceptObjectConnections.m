//
//  ConceptObjectConnections.m
//  ConceptMap
//
//  Created by Preston Rohner on 10/9/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptObjectConnections.h"
#import "Utility.h"
#import "Concept.h"
#import "ConceptObject.h"
#import "DataController.h"

@implementation ConceptObjectConnections


- (id)init {
	FUNCTION_LOG();
	[super init];
	
	connections = [[NSMutableDictionary alloc] init];
	return self;
}

- (void)drawInContext:(CGContextRef)context {
	FUNCTION_LOG();
		
	CGContextSetLineWidth(context, 3.0);
	CGPoint pt;
	for (NSString *key in connections) {
		ConceptObjectConnection *cxn = (ConceptObjectConnection *)[connections valueForKey:key];
		pt = cxn.src.concept.centerPoint;
		pt = CGPointMake([cxn.src.concept.originX floatValue], [cxn.src.concept.originY floatValue]);
		pt = [cxn.src.layer convertPoint:pt toLayer:self];
		CGContextMoveToPoint(context, pt.x, pt.y);
		
		pt = cxn.dst.concept.centerPoint;
		pt = CGPointMake([cxn.dst.concept.originX floatValue], [cxn.dst.concept.originY floatValue]);
		pt = [cxn.dst.layer convertPoint:pt toLayer:self];
		CGContextAddLineToPoint(context, pt.x, pt.y);
		CGContextStrokePath(context);
	}
}

- (void)addConnectionFrom:(ConceptObject *)src to:(ConceptObject *)dst {
	ConceptObjectConnection *cxn = [[ConceptObjectConnection alloc] init];
	cxn.src = src;
	cxn.dst = dst;
	[connections setObject:cxn forKey:cxn.keyString];
	[self setNeedsDisplay];
}

@end
