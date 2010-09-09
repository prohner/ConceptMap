//
//  ConceptMapView.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptMapView.h"


@implementation ConceptMapView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
	CALayer *mainLayer = [CALayer layer];
	
	CGRect newBounds = self.bounds; 
	newBounds.origin = CGPointMake(0, 0);
	newBounds.size = CGSizeMake(200, 200);
	newBounds = [mainLayer convertRect:newBounds toLayer:self.layer];
	mainLayer.frame = newBounds;
	mainLayer.position = CGPointMake(200, 200);
	
	mainLayer.backgroundColor = [[UIColor purpleColor] CGColor];
	
	[self.layer addSublayer:mainLayer];
	[mainLayer setNeedsDisplay];
	
	mainLayer = [CALayer layer];
	newBounds.origin = CGPointMake(700, 700);
	newBounds.size = CGSizeMake(200, 200);
	newBounds = [mainLayer convertRect:newBounds toLayer:self.layer];
	mainLayer.frame = newBounds;
	mainLayer.position = CGPointMake(700, 700);
	
	mainLayer.backgroundColor = [[UIColor redColor] CGColor];
	
	[self.layer addSublayer:mainLayer];
	[mainLayer setNeedsDisplay];
	}

	return self;
}
//
//- (void)drawRect:(CGRect)rect {
//	
//}

//
//-(void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event 
//{	
//	NSLog(@"Touches Ended");
//	if (!self.dragging) {
//		[self.nextResponder touchesEnded: touches withEvent:event]; 
//	}		
//	
//	[super touchesEnded: touches withEvent: event];
//}

- (void)dealloc {
    [super dealloc];
}

- (CGSize)idealContentSize {
	return CGSizeMake(2000, 2000);
}

@end
