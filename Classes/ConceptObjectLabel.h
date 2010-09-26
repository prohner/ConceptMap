//
//  ConceptObjectLabel.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/14/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"

@class ConceptObject;

@interface ConceptObjectLabel : CALayer {
	NSString *title;
	int titleIndentation;
	int positionX;
	float fontSize;
	ConceptObject *conceptObject;
}

@property (nonatomic, retain) ConceptObject *conceptObject;
@property (nonatomic, retain) NSString *title;

@end
