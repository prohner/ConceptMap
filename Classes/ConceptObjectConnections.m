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
		FUNCTION_LOG(@"Src (%.2f, %.2f) %@", srcPoint.x, srcPoint.y, cxn.src.concept.title);
//		if (cxn.src.rootLayer != cxn.src.layer.superlayer) {
//			srcPoint = [cxn.src.layer.superlayer convertPoint:srcPoint toLayer:cxn.src.rootLayer];
//		}
		CGContextMoveToPoint(context, srcPoint.x, srcPoint.y);
		
		dstPoint = cxn.dst.concept.centerPoint;
		FUNCTION_LOG(@"Dst 1 (%.2f, %.2f) %@", dstPoint.x, dstPoint.y, cxn.dst.concept.title);
//		if (cxn.dst.rootLayer != cxn.dst.layer.superlayer) {
//			dstPoint = [cxn.dst.layer.superlayer convertPoint:dstPoint toLayer:cxn.dst.rootLayer];
//		}
//		FUNCTION_LOG(@"Dst 2 (%.2f, %.2f) %@", dstPoint.x, dstPoint.y, cxn.dst.concept.title);
//		dstPoint = [cxn.dst.layer.superlayer convertPoint:dstPoint toLayer:self];

//		CALayer *next = cxn.dst.layer.superlayer; 
//		while (self != next && next) {
//			next = next.superlayer;
//		}
//		dstPoint = [next convertPoint:dstPoint toLayer:self];

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
	FUNCTION_LOG(@"Key %@ (%i), %i connections now exist", cxn.keyString, cxn.keyString, [connections count]);
	[self setNeedsDisplay];
//	[cxn release];
}

- (void)removeConnectionFrom:(ConceptObject *)src to:(ConceptObject *)dst {
	ConceptObjectConnection *cxn = [[ConceptObjectConnection alloc] init];
	cxn.src = src;
	cxn.dst = dst;
	ConceptObjectConnection *cxn2delete = [connections objectForKey:cxn.keyString];
	[connections removeObjectForKey:cxn.keyString];
	
	FUNCTION_LOG(@"Key %@ (%i), %i connections remain (%i)", cxn.keyString, cxn.keyString, [connections count], cxn2delete);
	FUNCTION_LOG(@"From %@ to %@", src.concept.title, dst.concept.title);
	[self setNeedsDisplay];
//	[cxn release];
}

@end
