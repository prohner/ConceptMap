//
//  ConceptObjectConnection.m
//  ConceptMap
//
//  Created by Preston Rohner on 10/10/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptObjectConnection.h"
#import "ConceptObject.h"

@implementation ConceptObjectConnection

@synthesize src, dst, connectionDescription;;

- (void)dealloc {
	self.src = nil;
	self.dst = nil;
	self.connectionDescription = nil;
	
    [super dealloc];
}

- (NSString *)keyString {
	NSString *s = [[NSString alloc] initWithFormat:@"%i %i", src, dst];
	return s;
}


@end
