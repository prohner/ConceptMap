//
//  ConceptMapView.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptMapView.h"


@implementation ConceptMapView

@synthesize currentDocument;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		conceptObjects = [[NSMutableArray alloc] init];
		
        // Initialization code
		self.currentDocument = [DATABASE currentDocument];
		int i = 0;
		for (Concept *concept in [currentDocument concepts]) {
			ConceptObject *co = [ConceptObject conceptObjectWithConcept:concept];
			FUNCTION_LOG(@"%@ (%@, %@) (%@, %@) %i", concept.title, concept.originX, concept.originY, concept.width, concept.height, co);
			if (i++ % 2 == 0) {
				co.backgroundColor = [UIColor purpleColor];
			} else {
				co.backgroundColor = [UIColor greenColor];
			}
			
			[co setFrame:CGRectMake([concept.originX intValue], [concept.originY intValue], [concept.width intValue], [concept.height intValue])];
			UIView *containerView;
			if (concept.parentConcept) {
				containerView = [self getParentConceptObjectOf:concept];
			} else {
				containerView = self;
			}
			// TODO doublecheck the reference counts here...should I release after adding
			[self addConceptObject:co toView:containerView];

		}
		
		FUNCTION_LOG(@"View=(%i), Doc=(%i)", self, self.currentDocument);
		UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
		[self addGestureRecognizer:singleTap];
		[singleTap release];
	}

	return self;
}

- (void)dealloc {
    [super dealloc];
}

- (ConceptObject *)getParentConceptObjectOf:(Concept *)concept {
	FUNCTION_LOG();
	ConceptObject *parentConceptObject = nil;
	for (ConceptObject *co in conceptObjects) {
		if (co.concept == concept.parentConcept) {
			parentConceptObject	= co;
			FUNCTION_LOG(@"%@ goes into %@", concept.title, parentConceptObject.concept.title);
			break;
		}
	}
	return parentConceptObject;
}

- (void)addConceptObject:(ConceptObject *)co toView:(UIView *)view {
	co.myDelegate = self;
	[view addSubview:co];
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

	//FUNCTION_LOG(@"(%.2f, %.2f) %i", panPoint.x, panPoint.y, [conceptObjects count]);
	
	BOOL foundHomeForPanningObject = NO;
	for (ConceptObject *possibleDropTargetCandidate in conceptObjects) {
		CGPoint receiverPoint = [self.layer convertPoint:panPoint toLayer:possibleDropTargetCandidate.layer];
		if ([possibleDropTargetCandidate.layer containsPoint:receiverPoint] 
			&& possibleDropTargetCandidate != conceptObject) {
			
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

- (void)conceptObject:(ConceptObject *)conceptObject panningEnded:(UIPanGestureRecognizer *)sender {
	if (possibleDropTarget) {
		// TODO keep track of items inside drop target so it knows who it owns
		
		FUNCTION_LOG(@"New position (%i, %i)", conceptObject.layer.position.x, conceptObject.layer.position.y);
		possibleDropTarget.isActiveDropTarget = NO;
		[conceptObject removeFromSuperview];

		CGPoint pt = conceptObject.layer.position;
		pt = [self.layer convertPoint:pt toLayer:conceptObject.layer];
		
		[possibleDropTarget addConceptObject:conceptObject];

	} else {
		if (conceptObject.superview != self) {
			FUNCTION_LOG(@"Just drop it");
			CGPoint pt = conceptObject.layer.position;
			pt = [conceptObject.layer convertPoint:pt toLayer:self.layer];
			[conceptObject removeFromSuperview];
			conceptObject.layer.position = pt;
			[self addSubview:conceptObject];
		} else {
			FUNCTION_LOG(@"Do nothing special");
		}

	}

}

@end
