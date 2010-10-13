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
	CGPoint srcPoint, dstPoint;
	for (NSString *key in connections) {
		ConceptObjectConnection *cxn = (ConceptObjectConnection *)[connections valueForKey:key];

		srcPoint = cxn.src.concept.centerPoint;
		FUNCTION_LOG(@"Src (%.2f, %.2f)", srcPoint.x, srcPoint.y);
		srcPoint = [cxn.src.layer.superlayer convertPoint:srcPoint toLayer:cxn.src.rootLayer];
		CGContextMoveToPoint(context, srcPoint.x, srcPoint.y);
		
		dstPoint = cxn.dst.concept.centerPoint;
		FUNCTION_LOG(@"Dst (%.2f, %.2f)", dstPoint.x, dstPoint.y);
		dstPoint = [cxn.dst.layer.superlayer convertPoint:dstPoint toLayer:cxn.dst.rootLayer];
		CGContextAddLineToPoint(context, dstPoint.x, dstPoint.y);

		CGContextStrokePath(context);
		FUNCTION_LOG(@"Draw from (%.2f, %.2f) to (%.2f, %.2f)", srcPoint.x, srcPoint.y, dstPoint.x, dstPoint.y);
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
