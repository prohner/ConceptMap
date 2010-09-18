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
		conceptObjects = [[NSMutableArray alloc] init];
		
        // Initialization code
		Document *doc = [DATABASE currentDocument];
		int i = 0;
		for (Concept *concept in [doc concepts]) {
			ConceptObject *co = [ConceptObject conceptObjectWithConcept:concept];
			FUNCTION_LOG(@"%@ (%@, %@) (%@, %@) %i", concept.title, concept.originX, concept.originY, concept.width, concept.height, co);
			if (i++ % 2 == 0) {
				co.backgroundColor = [UIColor purpleColor];
			} else {
				co.backgroundColor = [UIColor greenColor];
			}

			[co setFrame:CGRectMake([concept.originX intValue], [concept.originY intValue], [concept.width intValue], [concept.height intValue])];
			// TODO doublecheck the reference counts here...should I release after adding
			[self addConceptObjectToView:co];
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

- (void)addConceptObjectToView:(ConceptObject *)co {
	co.delegate = self;
	[self addSubview:co];
	[conceptObjects addObject:co];
}

- (CGSize)idealContentSize {
	return CGSizeMake(2000, 2000);
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    // single tap does nothing for now
	FUNCTION_LOG();
	[selectedConceptObject setSelected:NO];	// Unselect already selected one
}

#pragma mark ConceptObjectDelegate
- (void)conceptObject:(ConceptObject *)conceptObject isSelected:(BOOL)isSelected {
	FUNCTION_LOG();
	if (isSelected) {
		[selectedConceptObject setSelected:NO];	// Unselect already selected one
		selectedConceptObject = conceptObject;
	} else {
		
		selectedConceptObject = nil;
	}
}

- (void)conceptObject:(ConceptObject *)conceptObject isPanning:(UIPanGestureRecognizer *)sender {
	CGPoint panPoint = [sender locationInView:self];
	//viewPoint = [self convertPoint:viewPoint toView:self];

	FUNCTION_LOG(@"(%.2f, %.2f) %i", panPoint.x, panPoint.y, [conceptObjects count]);
	
//	CALayer *hitLayer = [self.layer hitTest:panPoint];
//	if ([hitLayer isKindOfClass:[ConceptObject class]]) {
//		FUNCTION_LOG(@"Floating over");
//		ConceptObject *co = (ConceptObject *)hitLayer;
//		[co setSelected:YES];
//	} else {
//		FUNCTION_LOG(@"obj=%i, hit=%i, self=%i %@", conceptObject, hitLayer, self.layer, [hitLayer class]);
//	}
	BOOL foundHomeForPanningObject = NO;
	for (ConceptObject *possibleDropTargetCandidate in conceptObjects) {
		if ([possibleDropTargetCandidate.layer containsPoint:panPoint] && possibleDropTargetCandidate != conceptObject) {
			FUNCTION_LOG(@"GOT IT! %@", possibleDropTargetCandidate.concept.title);
			possibleDropTargetCandidate.isActiveDropTarget = YES;
			possibleDropTarget = possibleDropTargetCandidate;
			foundHomeForPanningObject = YES;
		} 
	}
	
	if (!foundHomeForPanningObject) {
		possibleDropTarget.isActiveDropTarget = NO;
		possibleDropTarget = nil;
	}
	
}

@end
