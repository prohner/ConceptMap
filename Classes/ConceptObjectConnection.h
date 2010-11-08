//
//  ConceptObjectConnection.h
//  ConceptMap
//
//  Created by Preston Rohner on 10/10/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class ConceptObject;

@interface ConceptObjectConnection : NSObject {
	ConceptObject *src;
	ConceptObject *dst;
	NSString *connectionDescription;
	CATextLayer *layer;
}

@property (nonatomic, retain) ConceptObject *src;
@property (nonatomic, retain) ConceptObject *dst;
@property (nonatomic, retain) NSString *connectionDescription;
@property (nonatomic, retain) CATextLayer *layer;
@property (nonatomic, readonly) NSString *keyString;

- (void)initSource:(ConceptObject *)source dest:(ConceptObject *)dest label:(NSString *)label;
@end
