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
#import "ConceptObjectColorSet.h"
#import "ConceptObjectDeleteButton.h"
#import "ConceptObjectConnectButton.h"

@protocol ConceptObjectDelegate;

@interface ConceptObject : UIView <UIAlertViewDelegate, UITextViewDelegate, UIPopoverControllerDelegate> {
	UIView *myContainingView;
	BOOL selected;
	BOOL isConnecting;
	
	Concept *concept;
	
    id <ConceptObjectDelegate> myDelegate;
	
	ConceptObjectDeleteButton *deleteButton;
	ConceptObjectConnectButton *connectButton;
	ConceptObjectLabel *conceptObjectLabel;
	UIButton *settingsButton;
	ConceptObjectTitleViewController *conceptObjectTitleViewController;
	ConceptObjectSettingsViewController *conceptObjectSettingsViewController;
	CGFloat pinchScale;
	CGPoint dragLastPoint;
	
	NSArray *childConceptObjects;
	
	UITextView *bodyDisplayString;
	
	BOOL holdSelected;
	BOOL isActiveDropTarget;
}

@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL isConnecting;
@property (nonatomic) BOOL isActiveDropTarget;
@property (nonatomic, retain) id <ConceptObjectDelegate> myDelegate;
@property (nonatomic, retain) Concept *concept;
@property (nonatomic, retain) ConceptObjectLabel *conceptObjectLabel;
@property (nonatomic, retain) NSArray *childConceptObjects;

+ (ConceptObject *)conceptObjectWithConcept:(Concept *)concept;
- (void)addConceptObject:(ConceptObject *)newConceptObject;
- (void)removeConceptObject:(ConceptObject *)newConceptObject;
- (void)removeFromParentConceptObject;
- (void)setConceptColorScheme:(ColorSchemeConstant)newColor;
- (void)bodyDisplayStringBecameActive:(id)sender;
- (void)setBodyDisplayStringFont;
- (void)setLayerTreeFrom:(CALayer *)layer toMasksToBounds:(BOOL)newValue;
- (void)setConceptSize:(CGSize)newSize;

@end

@protocol ConceptObjectDelegate 

- (void)conceptObject:(ConceptObject *)conceptObject isSelected:(BOOL)isSelected;
- (void)conceptObject:(ConceptObject *)conceptObject isPanning:(UIPanGestureRecognizer *)sender;
- (void)conceptObject:(ConceptObject *)conceptObject panningEnded:(UIPanGestureRecognizer *)sender;
- (void)conceptObject:(ConceptObject *)conceptObject connecting:(BOOL)isConnecting;
- (BOOL)conceptObject:(ConceptObject *)conceptObject connected:(BOOL)isConnected;


@end

@interface Concept(UserInterface)
- (ConceptObjectColorSet *)conceptObjectColorSet;
@end

