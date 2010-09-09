//
//  ConceptObject.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptObject.h"


@implementation ConceptObject

- (id)init {
	[super init];
    self.borderWidth = 2;
    self.cornerRadius = 12;

	
	return self;
}

- (IBAction)handleObjectTapGesture:(UITapGestureRecognizer *)sender {
	FUNCTION_LOG();
}

- (IBAction)handleObjectPinchGesture:(UITapGestureRecognizer *)sender {
	FUNCTION_LOG();
}

- (void)addToView:(UIView *)view {
	myContainingView = view;
	[view.layer addSublayer:self];

	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
										  initWithTarget:self action:@selector(handleObjectTapGesture:)];
	[myContainingView addGestureRecognizer:tapGesture];
	[tapGesture release];
	
	UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] 
											  initWithTarget:self action:@selector(handleObjectPinchGesture:)];
	[myContainingView addGestureRecognizer:pinchGesture];
	[pinchGesture release];
}
@end
