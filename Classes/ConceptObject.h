//
//  ConceptObject.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
#import "DataController.h"
#import "ConceptObjectLabel.h"

@protocol ConceptObjectDelegate;

@interface ConceptObject : UIView {
	UIView *myContainingView;
	BOOL selected;
	
	Concept *concept;
	
    id <ConceptObjectDelegate> myDelegate;
	
	CATextLayer *deleteBox;
	ConceptObjectLabel *conceptObjectLabel;
	CGFloat pinchScale;
	CGPoint dragLastPoint;
	
	BOOL holdSelected;
	BOOL isActiveDropTarget;
}

@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL isActiveDropTarget;
@property (nonatomic, retain) id <ConceptObjectDelegate> myDelegate;
@property (nonatomic, retain) Concept *concept;

+ (ConceptObject *)conceptObjectWithConcept:(Concept *)concept;

@end

@protocol ConceptObjectDelegate 

- (void)conceptObject:(ConceptObject *)conceptObject isSelected:(BOOL)isSelected;
- (void)conceptObject:(ConceptObject *)conceptObject isPanning:(UIPanGestureRecognizer *)sender;
- (void)conceptObject:(ConceptObject *)conceptObject panningEnded:(UIPanGestureRecognizer *)sender;


@end

