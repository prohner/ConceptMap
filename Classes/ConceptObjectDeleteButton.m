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
	

	CGMutablePathRef myPath = CGPathCreateMutable();
	float indent = 5;
	CGPathMoveToPoint(myPath,    NULL,  0.0 + indent, 0.0 + indent);
	CGPathAddLineToPoint(myPath, NULL,  self.bounds.size.height - indent, self.bounds.size.width - indent);

	CGPathMoveToPoint(myPath,    NULL,  0.0 + indent,  self.bounds.size.width - indent);
	CGPathAddLineToPoint(myPath, NULL,  self.bounds.size.height - indent, 0.0 + indent);

	CGContextBeginPath(theContext);
	CGContextAddPath(theContext, myPath);

	CGContextSetStrokeColorWithColor(theContext, conceptObject.concept.conceptObjectColorSet.titleForegroundColor.CGColor);
	CGContextSetLineWidth(theContext, 3.0);
	CGContextStrokePath(theContext);
	
	CFRelease(myPath);
	
	UIGraphicsPopContext();
	
}

- (void)dealloc {
    [super dealloc];
}


@end
