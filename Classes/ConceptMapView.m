//
//  ConceptMapView.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptMapView.h"
#import "ConceptObjectConnections.h"

@implementation ConceptMapView

static int recursionDepth = 0;

@synthesize currentDocument, propertyInspectorButton, toolbar;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		conceptObjectConnections = [ConceptObjectConnections layer];
		conceptObjectConnections.frame = CGRectMake(0, 0, 768, 1024);
		//	connectionsLayer.backgroundColor = [[UIColor greenColor] CGColor];
		conceptObjectConnections.backgroundColor = [[UIColor colorWithRed:.5 green:.5 blue:1 alpha:1] CGColor];
		
		[self.layer addSublayer:conceptObjectConnections];

		self.currentDocument = [DATABASE currentDocument];
		[self addSetOfConcepts:[currentDocument concepts] toConceptObject:nil withTabs:@"\t"];
		
		FUNCTION_LOG(@"View=(%i), Doc=(%i)", self, self.currentDocument);
		UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
		[self addGestureRecognizer:singleTap];
		[singleTap release];

		UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
		doubleTap.numberOfTapsRequired = 2;
		[self addGestureRecognizer:doubleTap];
		[doubleTap release];
		
	}
	
	return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)addSetOfConcepts:(NSSet *)concepts toConceptObject:(ConceptObject *)conceptObject withTabs:(NSString *)tabs{
	for (Concept *concept in concepts) {
		if (conceptObject.concept == concept.parentConcept) {
			ConceptObject *co = [ConceptObject conceptObjectWithConcept:concept];
			FUNCTION_LOG(@"%@ %@ (%@, %@) (%@, %@) %i, color=%@", tabs, concept.title, concept.originX, concept.originY, concept.width, concept.height, co, concept.colorSchemeConstant);

			CGPoint pt = CGPointMake([concept.originX intValue], [concept.originY intValue]);
//			if (conceptObject != nil) {
//				pt = [self.layer convertPoint:pt toLayer:conceptObject.layer];
//			}
			LOG_POINT(pt);
			[co setFrame:CGRectMake(pt.x, pt.y, [concept.width intValue], [concept.height intValue])];
			
			// TODO doublecheck the reference counts here...should I release after adding
			NSString *tabs2 = [[NSString alloc] initWithFormat:@"%@\t", tabs];
			[self addConceptObject:co toView:conceptObject];
			[self addSetOfConcepts:concept.concepts toConceptObject:co withTabs:tabs2];
			[co release];
		}

	}
}

- (void)addConceptObject:(ConceptObject *)co toView:(UIView *)view {
	co.myDelegate = self;
	if (view == nil) {
		view = self;
	}
	[view addSubview:co];
}

- (CGSize)idealContentSize {
	return CGSizeMake(2000, 2000);
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    // single tap does nothing for now
	FUNCTION_LOG();
	[selectedConceptObject setSelected:NO];	// Unselect already selected one
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    // single tap does nothing for now
	FUNCTION_LOG(@"zoom scale == %.2f", self.zoomScale);
}

#pragma mark ConceptObjectDelegate

- (void)conceptObject:(ConceptObject *)conceptObject isSelected:(BOOL)isSelected {
	FUNCTION_LOG(@"setSelected=(%i)", isSelected);
	if (isSelected) {
		if (selectedConceptObject != conceptObject) {
			[selectedConceptObject setSelected:NO];	// Unselect already selected one
		}
		selectedConceptObject = conceptObject;
	} else {
		selectedConceptObject = nil;
	}
	
	propertyInspectorButton.enabled = isSelected;
}

- (void)conceptObject:(ConceptObject *)conceptObject isPanning:(UIPanGestureRecognizer *)sender {
	CGPoint panPoint = [sender locationInView:self];
	panningConceptObject = conceptObject;
	
	[conceptObjectConnections setNeedsDisplay];
	//viewPoint = [self convertPoint:viewPoint toView:self];

	//FUNCTION_LOG(@"(%.2f, %.2f) %i", panPoint.x, panPoint.y, [conceptObjects count]);
	
	FUNCTION_LOG(@"\nSearching tree");
	recursionDepth = 0;
	if ( ! [self setPossibleDropTargetForPoint:panPoint inConceptObject:self]) {
		possibleDropTarget.isActiveDropTarget = NO;
		possibleDropTarget = nil;
	}
#if FUNCTION_LOGGING
	else {
		FUNCTION_LOG(@"Found possibleDropTarget %@", possibleDropTarget.concept.title);
	}
#endif
	
}

- (BOOL)setPossibleDropTargetForPoint:(CGPoint)pt inConceptObject:(UIView *)view {
	BOOL foundHome = NO;
	recursionDepth++;
	FUNCTION_LOG(@"\t%i %@", recursionDepth, [view isKindOfClass:[ConceptObject class]] ? ((ConceptObject *)view).concept.title : @"non-ConceptObject");

	for (UIView *subview in view.subviews) {
		if ([subview isKindOfClass:[ConceptObject class]] && panningConceptObject != subview) {
			CGPoint receiverPoint = [self.layer convertPoint:pt toLayer:subview.layer];
			foundHome = [self setPossibleDropTargetForPoint:pt inConceptObject:subview];
			
			if (!foundHome) {
				if ([subview.layer containsPoint:receiverPoint] && panningConceptObject != subview) {
					foundHome = YES;
					possibleDropTarget.isActiveDropTarget = NO;	// Unhighlight any already highlighted
					possibleDropTarget = (ConceptObject *)subview;
					possibleDropTarget.isActiveDropTarget = YES;
				}
			}

			if (foundHome) {
				break;
			}

		}
	}
	
	return foundHome;
}

- (void)conceptObject:(ConceptObject *)conceptObject panningEnded:(UIPanGestureRecognizer *)sender {
	FUNCTION_LOG(@"possibleDropTarget %@", possibleDropTarget.concept.title);
	if (possibleDropTarget /*&& possibleDropTarget != conceptObject.superview*/) {
		// TODO keep track of items inside drop target so it knows who it owns
		
		FUNCTION_LOG(@"New position (%i, %i)", conceptObject.layer.position.x, conceptObject.layer.position.y);
		possibleDropTarget.isActiveDropTarget = NO;

		if (possibleDropTarget != conceptObject.superview) {
			CGPoint pt = conceptObject.layer.position;
			
			FUNCTION_LOG(@"1 (%.0f, %.0f)", pt.x, pt.y);
//			pt = [self.layer convertPoint:pt toLayer:self.layer];
//			FUNCTION_LOG(@"2 (%.0f, %.0f)", pt.x, pt.y);
			pt = [possibleDropTarget.layer convertPoint:pt fromLayer:conceptObject.superview.layer];
			FUNCTION_LOG(@"3 (%.0f, %.0f)", pt.x, pt.y);
			conceptObject.layer.position = pt;
			
			//pt = [self.layer convertPoint:pt toLayer:conceptObject.layer];
			//pt = [self.layer convertPoint:pt toLayer:possibleDropTarget.layer];
			
			[conceptObject removeFromSuperview];
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

- (void)conceptObject:(ConceptObject *)conceptObject  connecting:(BOOL)isConnecting {
	FUNCTION_LOG();
	sourceConceptObject = conceptObject;
}

- (BOOL)conceptObject:(ConceptObject *)conceptObject connected:(BOOL)isConnected {
	FUNCTION_LOG();
	BOOL result = NO;
	if (sourceConceptObject) {
		[sourceConceptObject.concept addConnectedConceptsObject:conceptObject.concept];
		[conceptObject.concept addConnectedConceptsObject:sourceConceptObject.concept];
		FUNCTION_LOG(@"Connect %@ to %@", sourceConceptObject.concept.title, conceptObject.concept.title);
		[conceptObjectConnections addConnectionFrom:sourceConceptObject to:conceptObject];
		result = YES;
	}
	sourceConceptObject = nil;
	return result;
}

- (UIImage *)conceptMapAsImage {
	toolbar.hidden = YES;
	UIGraphicsBeginImageContext(self.bounds.size);	
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	toolbar.hidden = NO;
	return viewImage;
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
