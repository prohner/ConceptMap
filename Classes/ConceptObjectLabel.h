//
//  ConceptObjectLabel.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/14/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@interface ConceptObjectLabel : CALayer {
	NSString *title;
	int titleIndentation;
	int positionX;
	float fontSize;
}

@property (nonatomic, retain) NSString *title;

@end
