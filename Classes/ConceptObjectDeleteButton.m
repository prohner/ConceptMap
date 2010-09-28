//
//  ConceptObjectDeleteButton.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/26/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptObjectDeleteButton.h"
#import "ConceptObject.h"

@implementation ConceptObjectDeleteButton

@synthesize conceptObject;

- (id)init {
	FUNCTION_LOG();
	[super init];

	UIImage *c = [UIImage imageNamed:@"delete.png"];
	self.contents = (id)c.CGImage;
	return self;
}

- (void)drawInContext:(CGContextRef)theContext {
	LOG_RECT(self.frame);
	UIGraphicsPushContext(theContext);
	
	CGContextSetStrokeColorWithColor(theContext, conceptObject.concept.conceptObjectColorSet.titleBackgroundColor.CGColor);
	CGContextSetLineWidth(theContext, 1.0);
	CGContextSetFillColorWithColor(theContext, conceptObject.concept.conceptObjectColorSet.titleBackgroundColor.CGColor);
	
	CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

	CGContextAddEllipseInRect(theContext, frame);
	CGContextFillPath(theContext);
	CGContextStrokePath(theContext);
	
	[@"abc" drawAtPoint:CGPointMake(0, 5) withFont:[UIFont systemFontOfSize:14]];

	UIGraphicsPopContext();
	
}

- (void)dealloc {
    [super dealloc];
}


@end
