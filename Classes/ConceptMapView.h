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

@interface ConceptMapView : UIScrollView <UIScrollViewDelegate, ConceptObjectDelegate> {
	ConceptObject *selectedConceptObject;
	ConceptObject *possibleDropTarget;
	ConceptObject *panningConceptObject;
	Document *currentDocument;
	UIBarButtonItem *propertyInspectorButton;
	UIToolbar *toolbar;
}

@property (nonatomic, retain) Document *currentDocument;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *propertyInspectorButton;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

- (CGSize)idealContentSize;
- (void)addConceptObject:(ConceptObject *)co toView:(UIView *)view;
- (void)addSetOfConcepts:(NSSet *)concepts toConceptObject:(ConceptObject *)conceptObject withTabs:(NSString *)tabs;
- (BOOL)setPossibleDropTargetForPoint:(CGPoint)pt inConceptObject:(UIView *)view;
- (UIImage *)conceptMapAsImage;

@end
