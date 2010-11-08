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

@synthesize src, dst, connectionDescription, layer, connectedConcept;

- (void)dealloc {
	self.src = nil;
	self.dst = nil;
	self.connectionDescription = nil;
	self.layer = nil;
	self.connectedConcept = nil;
	
    [super dealloc];
}

- (NSString *)keyString {
	NSString *s = [[NSString alloc] initWithFormat:@"%i %i", src, dst];
	return s;
}

- (NSString *)connectionDescription {
	return connectedConcept.connectionDescription;
}

- (void)initSource:(ConceptObject *)source dest:(ConceptObject *)dest label:(ConnectedConcept *)connectedConceptObject {
	self.src = source;
	self.dst = dest;
	self.connectionDescription = connectedConceptObject.connectionDescription;
	self.connectedConcept = connectedConceptObject;
	
	self.layer = [CATextLayer layer];
	self.layer.string = self.connectionDescription;
	self.layer.font = [UIFont systemFontOfSize:12];
	self.layer.foregroundColor = [UIColor lightGrayColor].CGColor;
	self.layer.backgroundColor = [UIColor clearColor].CGColor;
	self.layer.cornerRadius = 3;
	[self.layer setValue:LAYER_NAME_CONNECTLABEL forKey:LAYER_NAME];

//	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
//										  initWithTarget:self action:@selector(handleObjectTapGesture:)];
//	[self addGestureRecognizer:tapGesture];
//	[tapGesture release];
	
}

- (IBAction)handleObjectTapGesture:(UITapGestureRecognizer *)sender {
	FUNCTION_LOG();
}

@end
