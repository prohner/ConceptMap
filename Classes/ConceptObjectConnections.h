//
//  ConceptObjectConnections.h
//  ConceptMap
//
//  Created by Preston Rohner on 10/9/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "ConceptObjectConnection.h"
#import "ConnectionLabelViewController.h"

@class Concept;
@class ConceptObject;
@protocol ConnectionTouchSecondaryProcessorDelegate;


@interface ConceptObjectConnections : UIView <UIPopoverControllerDelegate> {
	NSMutableDictionary *connections;
	ConnectionLabelViewController *connectionLabelViewController;
    id <ConnectionTouchSecondaryProcessorDelegate> myDelegate;
}

@property (nonatomic, retain) ConnectionLabelViewController *connectionLabelViewController;
@property (nonatomic, retain) id <ConnectionTouchSecondaryProcessorDelegate> myDelegate;

- (void)addConnectionFrom:(ConceptObject *)src to:(ConceptObject *)dst with:(ConnectedConcept *)connectedConcept;
- (void)removeConnectionFrom:(ConceptObject *)src to:(ConceptObject *)dst;
- (void)removeConnectionsToAndFrom:(ConceptObject *)conceptObject;

@end

@protocol ConnectionTouchSecondaryProcessorDelegate 

- (IBAction)handleObjectTapGesture:(UITapGestureRecognizer *)sender;

@end

