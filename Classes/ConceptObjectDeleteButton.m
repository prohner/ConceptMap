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
	NSString * title = @"X";
	int fontSize = 18;
	UIGraphicsPushContext(theContext);
	
	UIFont *font = [UIFont systemFontOfSize:fontSize];
	CGSize size = [title sizeWithFont:font];
	
	CGContextSetStrokeColorWithColor(theContext, conceptObject.concept.conceptObjectColorSet.titleForegroundColor.CGColor);
	CGContextSetFillColorWithColor(theContext, conceptObject.concept.conceptObjectColorSet.titleForegroundColor.CGColor);
	CGContextAddEllipseInRect(theContext, self.frame);
	CGContextStrokePath(theContext);
	
//	//	CGPoint pointStartOfText = CGPointMake(textX, textY);
//	CGContextSetTextPosition(theContext, 0, 0);
	CGContextSetFillColorWithColor(theContext, conceptObject.concept.conceptObjectColorSet.titleBackgroundColor.CGColor);
	[title drawAtPoint:CGPointMake(self.bounds.size.width / 2 - size.width / 2
								   , self.bounds.size.height / 2 - size.height / 2 - self.borderWidth * 2) withFont:font];
	
	UIGraphicsPopContext();
	
}

- (void)dealloc {
    [super dealloc];
}


@end
