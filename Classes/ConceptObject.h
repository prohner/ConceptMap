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

@interface ConceptObject : CALayer {
	UIView *myContainingView;
	BOOL selected;
	
	CATextLayer *deleteBox;
}

@property (nonatomic) BOOL selected;

- (void)addToView:(UIView *)view;

@end
