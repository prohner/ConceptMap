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
		Document *doc = [DATABASE currentDocument];
		int i = 0;
		for (Concept *concept in [doc concepts]) {
			FUNCTION_LOG(@"%@ (%@, %@) (%@, %@)", concept.title, concept.originX, concept.originY, concept.width, concept.height);
			ConceptObject *co = [ConceptObject conceptObjectWithConcept:concept];
			if (i++ % 2 == 0) {
				co.backgroundColor = [UIColor purpleColor];
			} else {
				co.backgroundColor = [UIColor greenColor];
			}

			//co.delegate = self;
			[self addSubview:co];
		}
		
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
