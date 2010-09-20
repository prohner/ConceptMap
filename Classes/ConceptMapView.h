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
}

@property (nonatomic, retain) Document *currentDocument;

- (CGSize)idealContentSize;
- (void)addConceptObjectToView:(ConceptObject *)co;

@end
