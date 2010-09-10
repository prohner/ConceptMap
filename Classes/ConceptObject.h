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

@protocol ConceptObjectDelegate;

@interface ConceptObject : UIView {
	UIView *myContainingView;
	BOOL selected;
	
    id <ConceptObjectDelegate> delegate;
	
	CATextLayer *deleteBox;
	CGFloat pinchScale;
}

@property (nonatomic) BOOL selected;
@property (nonatomic, retain) id <ConceptObjectDelegate> delegate;

@end

@protocol ConceptObjectDelegate 

- (void)conceptObject:(ConceptObject *)conceptObject isSelected:(BOOL)isSelected;

@end

