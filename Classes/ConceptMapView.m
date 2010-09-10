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
		
		ConceptObject *co1 = [[ConceptObject alloc] initWithFrame:CGRectMake(200, 200, 200, 200)];
		co1.backgroundColor = [UIColor purpleColor];
		co1.delegate = self;
		[self addSubview:co1];

		ConceptObject *co2 = [[ConceptObject alloc] initWithFrame:CGRectMake(700, 700, 200, 200)];
		co2.backgroundColor = [UIColor redColor];
		co2.delegate = self;
		[self addSubview:co2];
		
		UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
		[self addGestureRecognizer:singleTap];
		[singleTap release];
	}

	return self;
}

- (void)dealloc {
    [super dealloc];
}

- (CGSize)idealContentSize {
	return CGSizeMake(2000, 2000);
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    // single tap does nothing for now
	FUNCTION_LOG();
	[selectedConceptObject setSelected:NO];	// Unselect already selected one
}

- (void)conceptObject:(ConceptObject *)conceptObject isSelected:(BOOL)isSelected {
	FUNCTION_LOG();
	if (isSelected) {
		[selectedConceptObject setSelected:NO];	// Unselect already selected one
		selectedConceptObject = conceptObject;
	} else {
		
		selectedConceptObject = nil;
	}
}

@end
