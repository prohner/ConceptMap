//
//  ConceptMapView.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptMapView.h"


@implementation ConceptMapView

@synthesize currentDocument, propertyInspectorButton;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		conceptObjects = [[NSMutableArray alloc] init];
		
        // Initialization code
		self.currentDocument = [DATABASE currentDocument];
		for (Concept *concept in [currentDocument concepts]) {
			ConceptObject *co = [ConceptObject conceptObjectWithConcept:concept];
			FUNCTION_LOG(@"%@ (%@, %@) (%@, %@) %i, color=%@", concept.title, concept.originX, concept.originY, concept.width, concept.height, co, concept.colorSchemeConstant);
			
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
	
//	self.delegate = self;
//	self.minimumZoomScale = 1.0f;
//	self.maximumZoomScale = 5.0f;

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
	FUNCTION_LOG(@"btn=(%i)", propertyInspectorButton);
	if (isSelected) {
		[selectedConceptObject setSelected:NO];	// Unselect already selected one
		selectedConceptObject = conceptObject;
	} else {
		selectedConceptObject = nil;
	}
	
	propertyInspectorButton.enabled = isSelected;
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
			
			BOOL possibleCandidateIsChildOfPannedObject = NO;
			
			// Go up the tree and make sure we're not going to drop ourself onto a child
			CALayer *upLayer = possibleDropTargetCandidate.layer;
			while (upLayer != nil) {
				if (upLayer == conceptObject.layer) {
					possibleCandidateIsChildOfPannedObject = YES;
				}
				upLayer = upLayer.superlayer;
			}

			if (!possibleCandidateIsChildOfPannedObject) {
				//FUNCTION_LOG(@"GOT IT! %@", possibleDropTargetCandidate.concept.title);
				possibleDropTargetCandidate.isActiveDropTarget = YES;
				possibleDropTarget = possibleDropTargetCandidate;
				foundHomeForPanningObject = YES;
			}
		} 
	}
	
	if (!foundHomeForPanningObject) {
		possibleDropTarget.isActiveDropTarget = NO;
		possibleDropTarget = nil;
	}
	
}

- (void)conceptObject:(ConceptObject *)conceptObject panningEnded:(UIPanGestureRecognizer *)sender {
	FUNCTION_LOG(@"possibleDropTarget==%i",  possibleDropTarget);
	if (possibleDropTarget /*&& possibleDropTarget != conceptObject.superview*/) {
		// TODO keep track of items inside drop target so it knows who it owns
		
		FUNCTION_LOG(@"New position (%i, %i)", conceptObject.layer.position.x, conceptObject.layer.position.y);
		possibleDropTarget.isActiveDropTarget = NO;

		if (possibleDropTarget != conceptObject.superview) {
			[conceptObject removeFromSuperview];
			
			CGPoint pt = conceptObject.layer.position;
			
			FUNCTION_LOG(@"1 (%.0f, %.0f)", pt.x, pt.y);
			pt = [self.layer convertPoint:pt toLayer:self.layer];
			FUNCTION_LOG(@"2 (%.0f, %.0f)", pt.x, pt.y);
			pt = [possibleDropTarget convertPoint:pt fromView:self];
			FUNCTION_LOG(@"3 (%.0f, %.0f)", pt.x, pt.y);
			conceptObject.layer.position = pt;
			
			//pt = [self.layer convertPoint:pt toLayer:conceptObject.layer];
			//pt = [self.layer convertPoint:pt toLayer:possibleDropTarget.layer];
			
			[possibleDropTarget addConceptObject:conceptObject];
		}

	} else {
		if (conceptObject.superview != self) {
			FUNCTION_LOG(@"Just drop it");
			CGPoint pt = conceptObject.layer.position;
			FUNCTION_LOG(@"a (%.0f, %.0f)", pt.x, pt.y);
			pt = [conceptObject.layer.superlayer convertPoint:pt toLayer:self.layer];
//			pt = [sender locationInView:self];
			FUNCTION_LOG(@"b (%.0f, %.0f)", pt.x, pt.y);
			[conceptObject removeFromParentConceptObject];
			conceptObject.layer.position = pt;
			[self addSubview:conceptObject];
		} else {
			FUNCTION_LOG(@"Do nothing special");
		}

	}
	possibleDropTarget = nil;
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	FUNCTION_LOG();
	return scrollView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
	FUNCTION_LOG();
}


@end
