//
//  ConceptObjectConnectButton.m
//  ConceptMap
//
//  Created by Preston Rohner on 10/7/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptObjectConnectButton.h"
#import "ConceptObject.h"

@implementation ConceptObjectConnectButton

@synthesize conceptObject;

- (id)init {
	//	FUNCTION_LOG();
	[super init];
	
	//	UIImage *c = [UIImage imageNamed:@"delete.png"];
	//	self.contents = (id)c.CGImage;
	return self;
}

- (void)drawInContext:(CGContextRef)theContext {
	//	LOG_RECT(self.frame);
	FUNCTION_LOG();
	UIGraphicsPushContext(theContext);
	
	CGContextSetLineWidth(theContext, 1.0);
	CGContextSetFillColorWithColor(theContext, conceptObject.concept.conceptObjectColorSet.titleBackgroundColor.CGColor);
	CGContextSetFillColorWithColor(theContext, [UIColor clearColor].CGColor);
	
	CGFloat indent = 1.0f;
//	CGRect frame = CGRectMake(indent, indent, self.frame.size.width - (indent * 2), self.frame.size.height - (indent * 2));
//	CGContextAddEllipseInRect(theContext, frame);
//	CGContextFillPath(theContext);
	

	CGMutablePathRef myPath = CGPathCreateMutable();
//	float indent = 5;
//	CGPathMoveToPoint(myPath,    NULL,  0.0 + indent, 0.0 + indent);
//	CGPathAddLineToPoint(myPath, NULL,  self.bounds.size.height - indent, self.bounds.size.width - indent);
//	
//	CGPathMoveToPoint(myPath,    NULL,  0.0 + indent,  self.bounds.size.width - indent);
//	CGPathAddLineToPoint(myPath, NULL,  self.bounds.size.height - indent, 0.0 + indent);

	CGContextBeginPath(theContext);
	CGContextAddPath(theContext, myPath);

	CGContextSetFillColorWithColor(theContext, [UIColor clearColor].CGColor);
	CGRect frame = CGRectMake(indent, indent, self.frame.size.width - (indent * 2), self.frame.size.height - (indent * 2));
	CGContextAddEllipseInRect(theContext, frame);

	CGContextMoveToPoint(theContext, 10, 10);
//	CGFloat radius = 10.0f;

//	CGContextAddArc(theContext, 10.0, 20.0,  0.0,  0.0, M_PI/2.0, false);
//	CGContextAddArc(theContext,  0.0,  0.0, 20.0, 10.0, M_PI/5.0, false);
//    CGContextStrokePath(theContext);
	
//	CGContextSetStrokeColorWithColor(theContext, conceptObject.concept.conceptObjectColorSet.borderColor.CGColor);
//	CGContextSetStrokeColorWithColor(theContext, [UIColor redColor].CGColor);
//	CGContextSetLineWidth(theContext, 3.0);
	CGContextStrokePath(theContext);
	
	CFRelease(myPath);
	
	
	UIGraphicsPopContext();
	
}

- (void)dealloc {
    [super dealloc];
}


@end
