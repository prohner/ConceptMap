//
//  ConceptObjectLabel.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/14/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptObjectLabel.h"
#import "ConceptObject.h"

@implementation ConceptObjectLabel

@synthesize title, conceptObject;

- (id)init {
	[super init];
	
	titleIndentation = 1.0f;
	positionX = 30;
	fontSize = 14.0f;
	
	CGRect r;
	
	r = self.superlayer.bounds;
	r.origin.x  = 25;
	r.origin.y -= 5;
	r.size.height = 40;
	r.size.width = self.superlayer.bounds.size.width - 85 - 30;
	self.bounds = r;
	
	self.anchorPoint = CGPointZero;
	self.position = CGPointMake(10, 0);
	self.borderWidth = 0;
	self.cornerRadius = 5;
	self.needsDisplayOnBoundsChange = NO;
	self.backgroundColor = [[UIColor blackColor] CGColor];
	self.borderColor = [[UIColor yellowColor] CGColor];
	
	[self setValue:LAYER_NAME_TITLE forKey:LAYER_NAME];
	
	return self;
}

- (void)setTitle:(NSString *)newTitle {
	title = newTitle;
	
	UIFont *font = [UIFont systemFontOfSize:fontSize];
	CGSize size = [title sizeWithFont:font];
//	NSLog(@"%s size.width=%.2f, size.height=%.2f", __FUNCTION__, size.width, size.height);
	CGRect bounds = self.bounds;
	bounds.size.width = size.width + titleIndentation * 2 + self.borderWidth * 2 + positionX / 2;
	bounds.size.height = size.height + self.borderWidth * 2;
	self.bounds = bounds;
	[self setValue:newTitle forKey:@"myObjectName"];
	
	CALayer *parentLayer = (CALayer *)[self valueForKey:@"parentLayer"];
	[parentLayer setValue:newTitle forKey:@"myObjectName"];
	
	
}

- (void)drawInContext:(CGContextRef)theContext {
//	LOG_RECT(self.frame);
	title = [self valueForKey:@"myObjectName"];
//	NSLog(@"%s %@", __FUNCTION__, title);
	UIGraphicsPushContext(theContext);
	
	UIFont *font = [UIFont systemFontOfSize:fontSize];
	CGSize size = [title sizeWithFont:font];
	
	//	CGPoint pointStartOfText = CGPointMake(textX, textY);
	CGContextSetTextPosition(theContext, 0, 0);
	CGContextSetFillColorWithColor(theContext, conceptObject.concept.conceptObjectColorSet.titleForegroundColor.CGColor);
	
	[title drawAtPoint:CGPointMake(-80, self.bounds.size.height / 2 - size.height / 2 - 5) withFont:font];
	//	[title drawAtPoint:CGPointMake(5, 5) withFont:font];
	
	UIGraphicsPopContext();
	
}

- (void)displayLayer:(CALayer *)theLayer {
	NSLog(@"%s", __FUNCTION__);
}

@end
