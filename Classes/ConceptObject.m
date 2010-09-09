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

- (void)addToView:(UIView *)view {
	myContainingView = view;
	[view.layer addSublayer:self];

}
@end
