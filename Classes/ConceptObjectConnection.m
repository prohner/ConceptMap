//
//  ConceptObjectConnection.m
//  ConceptMap
//
//  Created by Preston Rohner on 10/10/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptObjectConnection.h"
#import "ConceptObject.h"
#import "Utility.h"

@implementation ConceptObjectConnection

@synthesize src, dst, connectionDescription, layer;

- (void)dealloc {
	self.src = nil;
	self.dst = nil;
	self.connectionDescription = nil;
	self.layer = nil;
	
    [super dealloc];
}

- (NSString *)keyString {
	NSString *s = [[NSString alloc] initWithFormat:@"%i %i", src, dst];
	return s;
}

- (void)initSource:(ConceptObject *)source dest:(ConceptObject *)dest label:(NSString *)label {
	self.src = source;
	self.dst = dest;
	self.connectionDescription = label;
	
	self.layer = [CATextLayer layer];
	self.layer.string = label;
	self.layer.font = [UIFont systemFontOfSize:12];
	self.layer.foregroundColor = [UIColor darkGrayColor].CGColor;
	self.layer.backgroundColor = [UIColor clearColor].CGColor;
	self.layer.cornerRadius = 3;

//	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
//										  initWithTarget:self action:@selector(handleObjectTapGesture:)];
//	[self addGestureRecognizer:tapGesture];
//	[tapGesture release];
	
}

- (IBAction)handleObjectTapGesture:(UITapGestureRecognizer *)sender {
	FUNCTION_LOG();
}

@end
