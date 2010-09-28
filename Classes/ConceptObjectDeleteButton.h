//
//  ConceptObjectDeleteButton.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/26/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"

@class ConceptObject;

@interface ConceptObjectDeleteButton : CALayer {
	ConceptObject *conceptObject;

}

@property (nonatomic, retain) ConceptObject *conceptObject;

@end
