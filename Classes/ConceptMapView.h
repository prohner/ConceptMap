//
//  ConceptMapView.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ConceptObject.h"
#import "DataController.h"
#import "ConceptObjectConnections.h"

@interface ConceptMapView : UIScrollView <UIScrollViewDelegate, ConceptObjectDelegate> {
	ConceptObject *selectedConceptObject;
	ConceptObject *possibleDropTarget;
	ConceptObject *panningConceptObject;
	ConceptObject *sourceConceptObject;
	Document *currentDocument;
	ConceptObjectConnections *conceptObjectConnections;
	UIToolbar *toolbar;
}

@property (nonatomic, retain) Document *currentDocument;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) ConceptObjectConnections *conceptObjectConnections;

- (CGSize)idealContentSize;
- (void)addConceptObject:(ConceptObject *)co toView:(UIView *)view;
- (void)addSetOfConcepts:(NSSet *)concepts toConceptObject:(ConceptObject *)conceptObject withTabs:(NSString *)tabs;
- (void)addConnections:(NSSet *)concepts;
- (BOOL)setPossibleDropTargetForPoint:(CGPoint)pt inConceptObject:(UIView *)view;
- (void)adjustChildCoordinates:(Concept *)mainConcept;
- (UIImage *)conceptMapAsImage;
- (void)rotated;
- (void)setDesktopImageTo:(UIImage *)image;

- (void)initializeContents;

@end
