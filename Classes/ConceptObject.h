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
#import "ConceptObjectTitleViewController.h"
#import "ConceptObjectSettingsViewController.h"

@protocol ConceptObjectDelegate;

@interface ConceptObject : UIView <UIAlertViewDelegate> {
	UIView *myContainingView;
	BOOL selected;
	
	Concept *concept;
	
    id <ConceptObjectDelegate> myDelegate;
	
	CALayer *deleteButton;
	ConceptObjectLabel *conceptObjectLabel;
	UIButton *settingsButton;
	ConceptObjectTitleViewController *conceptObjectTitleViewController;
	ConceptObjectSettingsViewController *conceptObjectSettingsViewController;
	CGFloat pinchScale;
	CGPoint dragLastPoint;
	
	UITextField *bodyDisplayString;
	
	BOOL holdSelected;
	BOOL isActiveDropTarget;
}

@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL isActiveDropTarget;
@property (nonatomic, retain) id <ConceptObjectDelegate> myDelegate;
@property (nonatomic, retain) Concept *concept;
@property (nonatomic, retain) ConceptObjectLabel *conceptObjectLabel;

+ (ConceptObject *)conceptObjectWithConcept:(Concept *)concept;
- (void)addConceptObject:(ConceptObject *)newConceptObject;

@end

@protocol ConceptObjectDelegate 

- (void)conceptObject:(ConceptObject *)conceptObject isSelected:(BOOL)isSelected;
- (void)conceptObject:(ConceptObject *)conceptObject isPanning:(UIPanGestureRecognizer *)sender;
- (void)conceptObject:(ConceptObject *)conceptObject panningEnded:(UIPanGestureRecognizer *)sender;


@end

