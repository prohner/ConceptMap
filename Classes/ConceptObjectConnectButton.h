//
//  ConceptObjectConnectButton.h
//  ConceptMap
//
//  Created by Preston Rohner on 10/7/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
	
@class ConceptObject;

@interface ConceptObjectConnectButton : CALayer {
	ConceptObject *conceptObject;
	
}

@property (nonatomic, retain) ConceptObject *conceptObject;


@end
