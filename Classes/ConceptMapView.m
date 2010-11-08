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

@synthesize currentDocument, toolbar, conceptObjectConnections;

//- (id)initWithFrame:(CGRect)frame {
//    if ((self = [super initWithFrame:frame])) {
//        // Initialization code
//		self.conceptObjectConnections = [ConceptObjectConnections layer];
//		conceptObjectConnections.frame = CGRectMake(0, 0, 768, 1024);
//		//	connectionsLayer.backgroundColor = [[UIColor greenColor] CGColor];
//		conceptObjectConnections.backgroundColor = [[UIColor colorWithRed:.5 green:.5 blue:1 alpha:1] CGColor];
//		
//		[self.layer addSublayer:conceptObjectConnections];
//
//		self.currentDocument = [DATABASE currentDocument];
//		[self addSetOfConcepts:[currentDocument concepts] toConceptObject:nil withTabs:@"\t"];
//		[self addConnections:[currentDocument concepts]];
//		
//		FUNCTION_LOG(@"View=(%i), Doc=(%i)", self, self.currentDocument);
//		UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//		[self addGestureRecognizer:singleTap];
//		[singleTap release];
//
//		UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
//		doubleTap.numberOfTapsRequired = 2;
//		[self addGestureRecognizer:doubleTap];
//		[doubleTap release];
//		
//	}
//	
//	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//	//conceptObjectConnections.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//	return self;
//}

- (void)initializeContents {
	self.conceptObjectConnections = [[ConceptObjectConnections alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
	conceptObjectConnections.backgroundColor = [UIColor clearColor];
	//conceptObjectConnections.backgroundColor = [[UIColor colorWithRed:.5 green:.5 blue:1 alpha:1] CGColor];
	
	self.layer.contents = (id)[[UIImage imageWithData:[DATABASE currentDocument].desktopImage] CGImage];
	[self.layer addSublayer:conceptObjectConnections.layer];
	
	self.currentDocument = [DATABASE currentDocument];
	[self addSetOfConcepts:[currentDocument concepts] toConceptObject:nil withTabs:@"\t"];
	
#ifdef DEBUG && 0
	for (Concept *concept in [[DATABASE currentDocument].concepts allObjects]) {
		FUNCTION_LOG(@"Connecting %@ (%@) to ....", concept.title, concept.objectID);
		for (ConnectedConcept *connectedConcept in [[concept connectedConcepts] allObjects]) {
			FUNCTION_LOG(@"\t\t %@ (%@).", connectedConcept.objectURL, connectedConcept.objectID);
		}
	}
#endif
	
	
	[self addConnections:[currentDocument concepts]];
	
	FUNCTION_LOG(@"View=(%i), Doc=(%i)", self, self.currentDocument);
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	[self addGestureRecognizer:singleTap];
	[singleTap release];
	
	UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	doubleTap.numberOfTapsRequired = 2;
	[self addGestureRecognizer:doubleTap];
	[doubleTap release];
	
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

}

- (void)rotated {
//	[super setFrame:frame];
	CGRect frame = self.frame;
	frame.origin.x = 0;
	frame.origin.y = 0;

	[CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:.1] forKey:kCATransactionAnimationDuration];

	[conceptObjectConnections setFrame:frame];
	[conceptObjectConnections setNeedsDisplay];

    [CATransaction commit];
}

- (void)dealloc {
    [super dealloc];
}

- (void)addConnections:(NSSet *)concepts {
	// ConceptObjects are all loaded and now draw connections
	for (Concept *concept in [concepts allObjects]) {
		FUNCTION_LOG(@"Connecting %@ to ....", concept.title);
		for (ConnectedConcept *connectedConcept in [[concept connectedConcepts] allObjects]) {
			FUNCTION_LOG(@"\t\t %@.", connectedConcept.objectURL);
			Concept *childConcept = (Concept *)[[DATABASE managedObjectContext] objectWithURI:[NSURL URLWithString:connectedConcept.objectURL]];
			[conceptObjectConnections addConnectionFrom:concept.conceptObject to:childConcept.conceptObject with:connectedConcept.connectionDescription];

//			[conceptObjectConnections addConnectionFrom:concept.conceptObject to:connectedConcept.conceptObject];
//			if (concepts != [concept connectedConcepts]) {
//				[self addConnections:[concept connectedConcepts]];
//			}
		}
	}
}

- (void)addSetOfConcepts:(NSSet *)concepts toConceptObject:(ConceptObject *)conceptObject withTabs:(NSString *)tabs{
	for (Concept *concept in concepts) {
		if (conceptObject.concept == concept.parentConcept) {
			ConceptObject *co = [ConceptObject conceptObjectWithConcept:concept];
			FUNCTION_LOG(@"%@ %@ (%@, %@) (%@, %@) %i, color=%@", tabs, concept.title, concept.originX, concept.originY, concept.width, concept.height, co, concept.colorSchemeConstant);

			CGPoint pt = CGPointMake([concept.originX intValue], [concept.originY intValue]);
			if (conceptObject == nil) {
				FUNCTION_LOG(@"\t\tConvert to CO");
				//pt = [self.layer convertPoint:pt toLayer:conceptObject.layer];
			} else {
				FUNCTION_LOG(@"\t\tConvert to self");
				pt = [self.layer convertPoint:pt toLayer:conceptObject.layer];
			}
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
	co.rootLayer = self.layer;
	co.conceptMapView = self;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	FUNCTION_LOG();
    return YES;
}

- (void)setDesktopImageTo:(UIImage *)image {
	self.layer.contents = (id)[image CGImage];
	[DATABASE currentDocument].desktopImage = UIImageJPEGRepresentation(image, 1.0);
	
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
}

- (void)conceptObject:(ConceptObject *)conceptObject isPanning:(UIPanGestureRecognizer *)sender {
	CGPoint panPoint = [sender locationInView:self];
	panningConceptObject = conceptObject;
	
	conceptObject.concept.originX = [NSNumber numberWithFloat:panPoint.x - ([conceptObject.concept.width floatValue] / 2)];
	conceptObject.concept.originY = [NSNumber numberWithFloat:panPoint.y - ([conceptObject.concept.height floatValue] / 2)];
	
	[conceptObjectConnections setNeedsDisplay];
	//viewPoint = [self convertPoint:viewPoint toView:self];

	//FUNCTION_LOG(@"Panning(%.2f, %.2f)", panPoint.x, panPoint.y);
	
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
	//LOG_CONCEPTOBJECT(conceptObject);

	[self adjustChildCoordinates:conceptObject.concept];
	[self.conceptObjectConnections.layer setNeedsDisplay];

}

- (BOOL)setPossibleDropTargetForPoint:(CGPoint)pt inConceptObject:(UIView *)view {
	BOOL foundHome = NO;
	recursionDepth++;
	//FUNCTION_LOG(@"\t%i %@", recursionDepth, [view isKindOfClass:[ConceptObject class]] ? ((ConceptObject *)view).concept.title : @"non-ConceptObject");

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
	LOG_CONCEPTOBJECT(conceptObject);
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
	
	LOG_CONCEPTOBJECT(conceptObject);
	[self adjustChildCoordinates:conceptObject.concept];
	[self.conceptObjectConnections.layer setNeedsDisplay];
	possibleDropTarget = nil;
}

- (void)adjustChildCoordinates:(Concept *)mainConcept {
	for (Concept *concept in [mainConcept concepts]) {
		CGRect frame = concept.conceptObject.frame;
		CGPoint pt = frame.origin;
		pt = [self.layer convertPoint:pt fromLayer:mainConcept.conceptObject.layer];
		concept.originX = [NSNumber numberWithFloat:pt.x];
		concept.originY = [NSNumber numberWithFloat:pt.y];

		LOG_CONCEPTOBJECT(concept.conceptObject);
		[self adjustChildCoordinates:concept];
	}
}

- (void)conceptObject:(ConceptObject *)conceptObject  connecting:(BOOL)isConnecting {
	FUNCTION_LOG();
	sourceConceptObject = conceptObject;
}

- (BOOL)conceptObject:(ConceptObject *)conceptObject connected:(BOOL)isConnected {
	FUNCTION_LOG();
	BOOL result = NO;
	if (sourceConceptObject) {
		sourceConceptObject.isConnecting = NO;
		[sourceConceptObject.concept addConnectionTo:conceptObject.concept];
//		[conceptObject.concept addConnectedConceptsObject:sourceConceptObject.concept];
		FUNCTION_LOG(@"Connect %@ to %@", sourceConceptObject.concept.title, conceptObject.concept.title);
		[conceptObjectConnections addConnectionFrom:sourceConceptObject to:conceptObject with:conceptObject.concept.title];
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
