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
		
		ConceptObject *co = [ConceptObject layer];
		co.frame = CGRectMake(0, 0, 200, 200);
		co.position = CGPointMake(200, 200);
		co.backgroundColor = [[UIColor purpleColor] CGColor];
		[co addToView:self];

		co = [ConceptObject layer];
		co.frame = CGRectMake(700, 700, 200, 200);
		co.position = CGPointMake(700, 700);
		co.backgroundColor = [[UIColor redColor] CGColor];
		[co addToView:self];
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
