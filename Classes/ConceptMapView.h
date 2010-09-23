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
	NSMutableArray *conceptObjects;
	ConceptObject *possibleDropTarget;
	Document *currentDocument;
	UIBarButtonItem *propertyInspectorButton;
}

@property (nonatomic, retain) Document *currentDocument;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *propertyInspectorButton;

- (CGSize)idealContentSize;
- (void)addConceptObject:(ConceptObject *)co toView:(UIView *)view;
- (ConceptObject *)getParentConceptObjectOf:(Concept *)concept;

@end
